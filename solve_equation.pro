function solve_equation,eps,han

r=(cos(eps)-sqrt(sin(han)^2-sin(eps)^2))/(1/sin(han)-sin(han))
return,r+r/sin(han)
end