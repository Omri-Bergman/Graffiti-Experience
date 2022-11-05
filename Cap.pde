class Cap {
  float spary_dist, radius;
  float circle_size_min, circle_size_max;
  float drip_size_min, drip_size_max;
  int drip_span_min, drip_span_max;
  int factor_speed;
  Cap(float _dist, float _rad, float _circ_min, float _circ_max, float _drip_size_min, float _drip_size_max, int _drip_span_min, int _drip_span_max, int _factor_speed) {
    spary_dist = _dist;
    radius = _rad;
    circle_size_min = _circ_min;
    circle_size_max = _circ_max;
    drip_size_min = _drip_size_min;
    drip_size_max = _drip_size_max;
    drip_span_min= _drip_span_min;
    drip_span_max = _drip_span_max;
    factor_speed = _factor_speed;
  }
}
