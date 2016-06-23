
vsim work.tb_basic -novopt

if {[batch_mode] == 0} {
  add log -r /*
  source top_wave.do
}
run 800 ns

