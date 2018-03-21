function new_dir = bounce_inside(pos, cur_dir)
    towards_origin = -pos;
    backwards = -cur_dir;
    proj = (dot(towards_origin, backwards)/dot(towards_origin, towards_origin))*towards_origin;
    new_dir = backwards - 2*(backwards - proj);
end