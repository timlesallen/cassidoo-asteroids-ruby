=begin

Given an array of integers representing asteroids in a row, for each
asteroid, the absolute value represents its size, and the sign represents
its direction (positive = right, negative = left). Return the state of the
asteroids after all collisions (assuming they are moving at the same speed).
If two asteroids meet, the smaller one will explode. When they are the same
size, they both explode. Asteroids moving in the same direction will never
meet.

Example:

$ asteroids([5, 8, -5])
$ [5, 8] // The 8 and -5 collide, 8 wins. The 5 and 8 never collide.

$ asteroids([10, -10])
$ [] // The 10 and -10 collide and they both explode.

=end

def right x
  x > 0
end

def left  x
  x < 0
end

def sign a
  a >= 0 ? '+' : '-'
end

def wins a, b
  # Moving in same direction or away from each other
  x = a.last
  y = b.first
  if sign(x) === sign(y) || left(x) && right(y) then
    'both'
  # Destroy each other
  elsif x.abs === y.abs then
    'neither';
  # Biggest wins
  else
    x.abs > y.abs ? 'left' : 'right'
  end
end

#  Given two sections, what is the result of placing them next to each other?
def merge a, b
  if a.length + b.length <= 1
    return a.concat(b);
  end
  # Make sure both sections have stable state within section
  a = asteroids(a);
  b = asteroids(b);
  # Now check what happens when they are placed next to each other.
  winner = wins(a, b)
  case winner
  when'neither'
    merge(a.slice(0, a.length - 1), b.slice(1..)); # Both asteroids at touch point are lost
  when 'left'
    merge(a, b.slice(1..)); # Left asteroid at touch point wins
  when 'right'
    merge(a.slice(0, a.length - 1), b); # Right asteroids at touch point wins
  else
    a.concat(b) # These sections are stable next to each other
  end
end

def asteroids input
  midpoint = input.length / 2
  merge(input.take(midpoint), input.slice(midpoint..));
end

class AssertionError < RuntimeError
end

def assert &block
    raise AssertionError unless yield
end

def test
  assert { asteroids([5, 8, -5]) === [5, 8] }# The 8 and -5 collide, 8 wins. The 5 and 8 never collide.
  assert { asteroids([1, 2, 3, 4, 5, 8, -10]) === [-10] }
  assert { asteroids([-10, 1, 2, 3, 4, 5, 8]) === [-10, 1, 2, 3, 4, 5, 8] }
  assert { asteroids([1, 2, 3, -3, 4, 5, 8]) === [1, 2, 4, 5, 8] }
  assert { asteroids([10, -10]) === [] } #  The 10 and -10 collide and they both explode.
  assert { asteroids([10, 10, -10, -10]) === [] } #  The 10 and -10 collide and they both explode.
end

test
