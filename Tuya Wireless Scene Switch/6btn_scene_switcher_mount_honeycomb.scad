include <libraries/BOSL2/std.scad>
include <hex plug library.scad>

// For: https://www.aliexpress.com/item/1005007701169536.html?spm=a2g0o.order_list.order_list_main.100.5da01802Ww4JTF
// Tuya ZigBee Wireless Scene Switch 6 Gang Push Button

module model() {
  internal_size = 86.35;
  wall = 2.25;
  outer_size = internal_size + wall * 2;
  height = 11 + wall;

  rect_tube(h=height, wall=wall, isize=[internal_size, internal_size], rounding=wall / 2, anchor=BOTTOM + CENTER) {
    position(BOTTOM) cuboid(size=[internal_size, internal_size, wall], anchor=BOTTOM) {
        position(CENTER) up(INSERT_LIP_HEIGHT / 2 - 0.5) xrot(180)
              insertEmpty();
      }
  }
}

model();
