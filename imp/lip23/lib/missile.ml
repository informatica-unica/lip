let mis_speed = 500
let mis_range = 700
let reload_cycles = 15
let explosion_cycles = 5

type status = AVAIL | FLYING | EXPLODING

type t = {
  mutable status : status;
  mutable cur_x : int;
  mutable cur_y : int;
  mutable beg_x : int;
  mutable beg_y : int;
  mutable last_x : int;
  mutable last_y : int;
  mutable heading : int;
  mutable count : int;
  mutable range : int;
  mutable travelled : int;
}

let init () =
  {
    status = AVAIL;
    cur_x = 0;
    cur_y = 0;
    beg_x = 0;
    beg_y = 0;
    last_x = 0;
    last_y = 0;
    heading = 0;
    count = 0;
    range = 0;
    travelled = 0;
  }
