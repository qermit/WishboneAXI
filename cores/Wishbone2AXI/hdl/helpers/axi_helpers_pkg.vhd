----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2016 11:46:54 PM
-- Design Name: 
-- Module Name: axi_helpers_pkg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package axi_helpers_pkg is
constant c_axi4_address_width : integer := 32;
constant c_axi4_data_width : integer := 128;
constant c_axi4_id_width : integer := 4;

type t_axi_interface_mode is (AXI4, AXI4LITE);


subtype t_axi4_address is
  std_logic_vector(c_axi4_address_width-1 downto 0);
  
  
  type t_axi4_m2s is record
     awid : std_logic_vector(c_axi4_id_width - 1 downto 0);
     awaddr :  STD_LOGIC_VECTOR(c_axi4_address_width-1 DOWNTO 0);
     awlen : STD_LOGIC_VECTOR(7 DOWNTO 0);
     awsize : STD_LOGIC_VECTOR(2 DOWNTO 0);
     awburst : STD_LOGIC_VECTOR(1 DOWNTO 0);
     awlock : STD_LOGIC;
     awcache : STD_LOGIC_VECTOR(3 DOWNTO 0);
     awregion: std_logic_vector(3 downto 0);
     awprot : STD_LOGIC_VECTOR(2 DOWNTO 0);
     awqos : STD_LOGIC_VECTOR(3 DOWNTO 0);
     awvalid : STD_LOGIC;     
     wdata : STD_LOGIC_VECTOR(c_axi4_data_width-1 DOWNTO 0);
     wstrb : STD_LOGIC_VECTOR(c_axi4_data_width/8 - 1 DOWNTO 0);
     wlast : STD_LOGIC;
     wvalid : STD_LOGIC;
     bready : STD_LOGIC;
     arid :  STD_LOGIC_VECTOR(c_axi4_id_width - 1 DOWNTO 0);
     araddr : STD_LOGIC_VECTOR(c_axi4_address_width-1 DOWNTO 0);
     arlen :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     arsize :  STD_LOGIC_VECTOR(2 DOWNTO 0);
     arburst : STD_LOGIC_VECTOR(1 DOWNTO 0);
     arlock :  STD_LOGIC;
     arcache : STD_LOGIC_VECTOR(3 DOWNTO 0);
     arregion: std_logic_vector(3 downto 0);
     arprot :  STD_LOGIC_VECTOR(2 DOWNTO 0);
     arqos : STD_LOGIC_VECTOR(3 DOWNTO 0);
     arvalid : STD_LOGIC;
     rready : STD_LOGIC;
  end record t_axi4_m2s;
  

  type t_axi4_s2m is record
     awready : STD_LOGIC;
     wready : STD_LOGIC;
     bid : STD_LOGIC_VECTOR(c_axi4_id_width - 1 DOWNTO 0);
     bresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
     bvalid : STD_LOGIC;
     arready : STD_LOGIC;
     rid : STD_LOGIC_VECTOR(c_axi4_id_width - 1 DOWNTO 0);
     rdata : STD_LOGIC_VECTOR(c_axi4_data_width-1 DOWNTO 0);
     rresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
     rlast : STD_LOGIC;
     rvalid :  STD_LOGIC;
  end record t_axi4_s2m;  
  
  type t_axi4_datagen is record
     waddr :  STD_LOGIC_VECTOR(31 DOWNTO 0);
     wdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
     wvalid : STD_LOGIC;
     raddr :  STD_LOGIC_VECTOR(31 DOWNTO 0);
     rdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
     rvalid : STD_LOGIC;
  end record t_axi4_datagen;
  
  type t_axi4_m2s_array is array (natural range <>) of t_axi4_m2s;
  type t_axi4_s2m_array is array (natural range <>) of t_axi4_s2m;
  type t_axi4_datagen_array is array (natural range <>) of t_axi4_datagen;
  
  COMPONENT axi_crossbar_wrapper
    GENERIC (
      g_master_ports: natural := 3;
      g_slave_ports : natural := 3
    );
    PORT (
       aclk : in std_logic;
       aresetn : in std_logic;
       
       s_axi4_m2s : in t_axi4_m2s_array(g_slave_ports-1 downto 0);
       s_axi4_s2m : out t_axi4_s2m_array(g_slave_ports-1 downto 0);
       m_axi4_m2s : out t_axi4_m2s_array(g_master_ports-1 downto 0);
       m_axi4_s2m : in t_axi4_s2m_array(g_master_ports-1 downto 0)
    );
    end component;
    

component axi_dwidth_wrapper is
generic (
  g_master_width: natural:= 32;
  g_slave_width: natural:= 128
);
port (
    aclk : in std_logic;
    aresetn : in std_logic;
    
    s_axi4_m2s : in t_axi4_m2s;
    s_axi4_s2m : out t_axi4_s2m;
    m_axi4_m2s : out t_axi4_m2s;
    m_axi4_s2m : in t_axi4_s2m
);
end component;
    

 
  COMPONENT axi_crossbar_main
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awid : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_awaddr : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
      s_axi_awlen : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      s_axi_awsize : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_awburst : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_awlock : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awcache : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_awqos : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_wdata : IN STD_LOGIC_VECTOR(383 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      s_axi_wlast : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_wready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_bid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_bresp : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_bready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arid : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_araddr : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
      s_axi_arlen : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      s_axi_arsize : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_arburst : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_arlock : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arcache : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_arqos : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_rid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_rdata : OUT STD_LOGIC_VECTOR(383 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_rlast : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_rready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
      m_axi_awlen : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      m_axi_awsize : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      m_axi_awburst : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_awlock : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awcache : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      m_axi_awregion : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_awqos : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_wdata : OUT STD_LOGIC_VECTOR(383 DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      m_axi_wlast : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_wready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_bid : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_bresp : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_bready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_araddr : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
      m_axi_arlen : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      m_axi_arsize : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      m_axi_arburst : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_arlock : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arcache : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      m_axi_arregion : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_arqos : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_rid : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_rdata : IN STD_LOGIC_VECTOR(383 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_rlast : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_rready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
  END COMPONENT;

  function f_axitype_to_str(x   : t_axi_interface_mode) return string;
  


 constant c_axi_m2s_dummy: t_axi4_m2s := (
     awid => ( others => '0' ),
     awaddr => ( others => '0' ),
     awlen => ( others => '0' ),
     awsize => ( others => '0' ),
     awburst => ( others => '0' ),
     awlock => '0',
     awcache => ( others => '0' ),
     awregion => ( others => '0' ),
     awprot => ( others => '0' ),
     awqos => ( others => '0' ),
     awvalid => '0',     
     wdata => ( others => '0' ),
     wstrb => ( others => '0' ),
     wlast => '0',
     wvalid => '0',
     bready => '0',
     arid => ( others => '0' ),
     araddr => ( others => '0' ),
     arlen => ( others => '0' ),
     arsize => ( others => '0' ),
     arburst => ( others => '0' ),
     arlock => '0',
     arcache => ( others => '0' ),
     arregion => ( others => '0' ),
     arprot => ( others => '0' ),
     arqos => ( others => '0' ),
     arvalid => '0',
     rready => '0'
   );
  
end axi_helpers_pkg;

package body  axi_helpers_pkg is

  function f_axitype_to_str(x : t_axi_interface_mode) return string is
  begin
    if x = AXI4 then return "AXI4";
    elsif x = AXI4LITE then return "AXI4LITE";
    else return "AXI4";
    end if;
  end f_axitype_to_str;
  
end axi_helpers_pkg;
