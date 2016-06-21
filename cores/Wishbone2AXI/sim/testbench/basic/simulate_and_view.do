
vsim work.tb_basic

if {[batch_mode] == 0} {
  add log -r /*
  source top_wave.do
}
run 500 ns

