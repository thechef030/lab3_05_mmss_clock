# Combo II-DLD S75 / MAIN CLOCK F = 50 MHz.

set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property PACKAGE_PIN K4 [get_ports rst_p]

set_property PACKAGE_PIN H2 [get_ports {seg_data[0]}]
set_property PACKAGE_PIN J7 [get_ports {seg_data[1]}]
set_property PACKAGE_PIN J3 [get_ports {seg_data[2]}]
set_property PACKAGE_PIN J1 [get_ports {seg_data[3]}]
set_property PACKAGE_PIN E4 [get_ports {seg_data[4]}]
set_property PACKAGE_PIN E2 [get_ports {seg_data[5]}]
set_property PACKAGE_PIN F5 [get_ports {seg_data[6]}]
set_property PACKAGE_PIN F1 [get_ports {seg_data[7]}]

set_property PACKAGE_PIN K5 [get_ports {seg_com[0]}]
set_property PACKAGE_PIN K3 [get_ports {seg_com[1]}]
set_property PACKAGE_PIN K1 [get_ports {seg_com[2]}]
set_property PACKAGE_PIN L6 [get_ports {seg_com[3]}]
set_property PACKAGE_PIN G3 [get_ports {seg_com[4]}]
set_property PACKAGE_PIN G1 [get_ports {seg_com[5]}]
set_property PACKAGE_PIN H6 [get_ports {seg_com[6]}]
set_property PACKAGE_PIN H4 [get_ports {seg_com[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports *]

create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]

set_false_path -from [get_ports rst_p]
