function result = piecewise(x)
% Returns different results for different ranges of x.

x1 = 5.0;
x2 = 12.0;
x3 = 60.0;

a = 2;
b = 3;
c = 4;

if x < x1;
  result = a^2 + b^2;
elseif x >= x1 && x <= x2;
  result = a^2 + c^2;
elseif x > x2 && x < x3
  result = b^2 + c^2;
else
  result = 0.0;
end

end
