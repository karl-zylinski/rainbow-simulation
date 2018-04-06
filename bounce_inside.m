function new_dir = bounce_inside(pos, cur_dir)
    towards_origin = -pos./norm(pos);
    backwards = -cur_dir./norm(cur_dir);
    proj = (dot(towards_origin, backwards)/dot(towards_origin, towards_origin))*towards_origin;
    new_dir = backwards - 2*(backwards - proj);
end