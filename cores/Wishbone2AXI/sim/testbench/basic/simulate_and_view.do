
vopt -64 +acc -debugdb +cover=sbf work.tb_basic -o tb_basic_opt

vsim -debugdb -coverage tb_basic_opt

if {[batch_mode] == 0} {
  add log -r /*
  source top_wave.do
}
run 900 ns

