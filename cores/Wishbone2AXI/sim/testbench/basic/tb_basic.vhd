library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity tb_basic is
end;

architecture bench of tb_basic is

  constant C_S_WB_ADR_WIDTH         : natural := 32;
  constant C_S_WB_DAT_WIDTH         : natural := 32;
  constant C_M_WB_ADR_WIDTH         : natural := 32;
  constant C_M_WB_DAT_WIDTH         : natural := 32;
  constant C_S_AXI4_LITE_ADDR_WIDTH : natural := 32;
  constant C_S_AXI4_LITE_DATA_WIDTH : natural := 32;
  constant C_S_AXI4_ADDR_WIDTH      : natural := 32;
  constant C_S_AXI4_DATA_WIDTH      : natural := 32;
  constant C_S_AXI4_ID_WIDTH        : natural := 1;
  constant C_S_AXI4_ARUSER_WIDTH    : natural := 0;
  constant C_S_AXI4_AWUSER_WIDTH    : natural := 0;
  constant C_S_AXI4_BUSER_WIDTH     : natural := 0;
  constant C_S_AXI4_RUSER_WIDTH     : natural := 0;
  constant C_S_AXI4_WUSER_WIDTH     : natural := 0;
  constant C_M_AXI4_LITE_ADDR_WIDTH : natural := 32;
  constant C_M_AXI4_LITE_DATA_WIDTH : natural := 32;
  constant C_M_AXI4_ADDR_WIDTH      : natural := 32;
  constant C_M_AXI4_DATA_WIDTH      : natural := 32;
  constant C_M_AXI4_ID_WIDTH        : natural := 1;
  constant C_M_AXI4_ARUSER_WIDTH    : natural := 0;
  constant C_M_AXI4_AWUSER_WIDTH    : natural := 0;
  constant C_M_AXI4_BUSER_WIDTH     : natural := 0;
  constant C_M_AXI4_RUSER_WIDTH     : natural := 0;
  constant C_M_AXI4_WUSER_WIDTH     : natural := 0;
  constant C_M_AXI4_BURST_LEN       : natural := 4;

  signal s_wb_aclk           : std_logic;
  signal s_wb_aresetn        : std_logic;
  signal s_wb_adr            : std_logic_vector(C_S_WB_ADR_WIDTH-1 downto 0);
  signal s_wb_dat_w          : std_logic_vector(C_S_WB_DAT_WIDTH-1 downto 0);
  signal s_wb_cyc            : std_logic;
  signal s_wb_stb            : std_logic;
  signal s_wb_lock           : std_logic;
  signal s_wb_sel            : std_logic_vector(C_S_WB_DAT_WIDTH/8-1 downto 0);
  signal s_wb_we             : std_logic;
  signal s_wb_dat_r          : std_logic_vector(C_S_WB_DAT_WIDTH-1 downto 0);
  signal s_wb_stall          : std_logic;
  signal s_wb_err            : std_logic;
  signal s_wb_rty            : std_logic;
  signal s_wb_ack            : std_logic;
  signal m_wb_aclk           : std_logic;
  signal m_wb_aresetn        : std_logic;
  signal m_wb_adr            : std_logic_vector(C_M_WB_ADR_WIDTH-1 downto 0);
  signal m_wb_dat_w          : std_logic_vector(C_M_WB_DAT_WIDTH-1 downto 0);
  signal m_wb_cyc            : std_logic;
  signal m_wb_stb            : std_logic;
  signal m_wb_lock           : std_logic;
  signal m_wb_sel            : std_logic_vector(C_M_WB_DAT_WIDTH/8-1 downto 0);
  signal m_wb_we             : std_logic;
  signal m_wb_dat_r          : std_logic_vector(C_M_WB_DAT_WIDTH-1 downto 0);
  signal m_wb_stall          : std_logic;
  signal m_wb_err            : std_logic;
  signal m_wb_rty            : std_logic;
  signal m_wb_ack            : std_logic;
  signal s_axi4_lite_aclk    : std_logic;
  signal s_axi4_lite_aresetn : std_logic;
  signal s_axi4_lite_awaddr  : std_logic_vector(C_S_AXI4_LITE_ADDR_WIDTH-1 downto 0);
  signal s_axi4_lite_awprot  : std_logic_vector(2 downto 0);
  signal s_axi4_lite_awvalid : std_logic;
  signal s_axi4_lite_awready : std_logic;
  signal s_axi4_lite_wdata   : std_logic_vector(C_S_AXI4_LITE_DATA_WIDTH-1 downto 0);
  signal s_axi4_lite_wstrb   : std_logic_vector((C_S_AXI4_LITE_DATA_WIDTH/8)-1 downto 0);
  signal s_axi4_lite_wvalid  : std_logic;
  signal s_axi4_lite_wready  : std_logic;
  signal s_axi4_lite_bresp   : std_logic_vector(1 downto 0);
  signal s_axi4_lite_bvalid  : std_logic;
  signal s_axi4_lite_bready  : std_logic;
  signal s_axi4_lite_araddr  : std_logic_vector(C_S_AXI4_LITE_ADDR_WIDTH-1 downto 0);
  signal s_axi4_lite_arprot  : std_logic_vector(2 downto 0);
  signal s_axi4_lite_arvalid : std_logic;
  signal s_axi4_lite_arready : std_logic;
  signal s_axi4_lite_rdata   : std_logic_vector(C_S_AXI4_LITE_DATA_WIDTH-1 downto 0);
  signal s_axi4_lite_rresp   : std_logic_vector(1 downto 0);
  signal s_axi4_lite_rvalid  : std_logic;
  signal s_axi4_lite_rready  : std_logic;
  signal s_axi4_aclk         : std_logic;
  signal s_axi4_aresetn      : std_logic;
  signal s_axi4_awid         : std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
  signal s_axi4_awaddr       : std_logic_vector(C_S_AXI4_ADDR_WIDTH-1 downto 0);
  signal s_axi4_awlen        : std_logic_vector(7 downto 0) := (others => '0');
  signal s_axi4_awsize       : std_logic_vector(2 downto 0);
  signal s_axi4_awburst      : std_logic_vector(1 downto 0);
  signal s_axi4_awlock       : std_logic;
  signal s_axi4_awcache      : std_logic_vector(3 downto 0);
  signal s_axi4_awprot       : std_logic_vector(2 downto 0);
  signal s_axi4_awqos        : std_logic_vector(3 downto 0);
  signal s_axi4_awregion     : std_logic_vector(3 downto 0);
  signal s_axi4_awuser       : std_logic_vector(C_S_AXI4_AWUSER_WIDTH-1 downto 0);
  signal s_axi4_awvalid      : std_logic;
  signal s_axi4_awready      : std_logic;
  signal s_axi4_wdata        : std_logic_vector(C_S_AXI4_DATA_WIDTH-1 downto 0);
  signal s_axi4_wstrb        : std_logic_vector((C_S_AXI4_DATA_WIDTH/8)-1 downto 0);
  signal s_axi4_wlast        : std_logic;
  signal s_axi4_wuser        : std_logic_vector(C_S_AXI4_WUSER_WIDTH-1 downto 0);
  signal s_axi4_wvalid       : std_logic;
  signal s_axi4_wready       : std_logic;
  signal s_axi4_bid          : std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
  signal s_axi4_bresp        : std_logic_vector(1 downto 0);
  signal s_axi4_buser        : std_logic_vector(C_S_AXI4_BUSER_WIDTH-1 downto 0);
  signal s_axi4_bvalid       : std_logic;
  signal s_axi4_bready       : std_logic;
  signal s_axi4_arid         : std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
  signal s_axi4_araddr       : std_logic_vector(C_S_AXI4_ADDR_WIDTH-1 downto 0);
  signal s_axi4_arlen        : std_logic_vector(7 downto 0) := (others => '0');
  signal s_axi4_arsize       : std_logic_vector(2 downto 0);
  signal s_axi4_arburst      : std_logic_vector(1 downto 0);
  signal s_axi4_arlock       : std_logic;
  signal s_axi4_arcache      : std_logic_vector(3 downto 0);
  signal s_axi4_arprot       : std_logic_vector(2 downto 0);
  signal s_axi4_arqos        : std_logic_vector(3 downto 0);
  signal s_axi4_arregion     : std_logic_vector(3 downto 0);
  signal s_axi4_aruser       : std_logic_vector(C_S_AXI4_ARUSER_WIDTH-1 downto 0);
  signal s_axi4_arvalid      : std_logic;
  signal s_axi4_arready      : std_logic;
  signal s_axi4_rid          : std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
  signal s_axi4_rdata        : std_logic_vector(C_S_AXI4_DATA_WIDTH-1 downto 0);
  signal s_axi4_rresp        : std_logic_vector(1 downto 0);
  signal s_axi4_rlast        : std_logic;
  signal s_axi4_ruser        : std_logic_vector(C_S_AXI4_RUSER_WIDTH-1 downto 0);
  signal s_axi4_rvalid       : std_logic;
  signal s_axi4_rready       : std_logic;
  signal m_axi4_lite_aclk    : std_logic;
  signal m_axi4_lite_aresetn : std_logic;
  signal m_axi4_lite_awaddr  : std_logic_vector(C_M_AXI4_LITE_ADDR_WIDTH-1 downto 0);
  signal m_axi4_lite_awprot  : std_logic_vector(2 downto 0);
  signal m_axi4_lite_awvalid : std_logic;
  signal m_axi4_lite_awready : std_logic;
  signal m_axi4_lite_wdata   : std_logic_vector(C_M_AXI4_LITE_DATA_WIDTH-1 downto 0);
  signal m_axi4_lite_wstrb   : std_logic_vector(C_M_AXI4_LITE_DATA_WIDTH/8-1 downto 0);
  signal m_axi4_lite_wvalid  : std_logic;
  signal m_axi4_lite_wready  : std_logic;
  signal m_axi4_lite_bresp   : std_logic_vector(1 downto 0);
  signal m_axi4_lite_bvalid  : std_logic;
  signal m_axi4_lite_bready  : std_logic;
  signal m_axi4_lite_araddr  : std_logic_vector(C_M_AXI4_LITE_ADDR_WIDTH-1 downto 0);
  signal m_axi4_lite_arprot  : std_logic_vector(2 downto 0);
  signal m_axi4_lite_arvalid : std_logic;
  signal m_axi4_lite_arready : std_logic;
  signal m_axi4_lite_rdata   : std_logic_vector(C_M_AXI4_LITE_DATA_WIDTH-1 downto 0);
  signal m_axi4_lite_rresp   : std_logic_vector(1 downto 0);
  signal m_axi4_lite_rvalid  : std_logic;
  signal m_axi4_lite_rready  : std_logic;
  signal m_axi4_aclk         : std_logic;
  signal m_axi4_aresetn      : std_logic;
  signal m_axi4_awid         : std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
  signal m_axi4_awaddr       : std_logic_vector(C_M_AXI4_ADDR_WIDTH-1 downto 0);
  signal m_axi4_awlen        : std_logic_vector(7 downto 0) := (others => '0');
  signal m_axi4_awsize       : std_logic_vector(2 downto 0);
  signal m_axi4_awburst      : std_logic_vector(1 downto 0);
  signal m_axi4_awlock       : std_logic;
  signal m_axi4_awcache      : std_logic_vector(3 downto 0);
  signal m_axi4_awprot       : std_logic_vector(2 downto 0);
  signal m_axi4_awqos        : std_logic_vector(3 downto 0);
  signal m_axi4_awuser       : std_logic_vector(C_M_AXI4_AWUSER_WIDTH-1 downto 0);
  signal m_axi4_awvalid      : std_logic;
  signal m_axi4_awready      : std_logic;
  signal m_axi4_wdata        : std_logic_vector(C_M_AXI4_DATA_WIDTH-1 downto 0);
  signal m_axi4_wstrb        : std_logic_vector(C_M_AXI4_DATA_WIDTH/8-1 downto 0);
  signal m_axi4_wlast        : std_logic;
  signal m_axi4_wuser        : std_logic_vector(C_M_AXI4_WUSER_WIDTH-1 downto 0);
  signal m_axi4_wvalid       : std_logic;
  signal m_axi4_wready       : std_logic;
  signal m_axi4_bid          : std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
  signal m_axi4_bresp        : std_logic_vector(1 downto 0);
  signal m_axi4_buser        : std_logic_vector(C_M_AXI4_BUSER_WIDTH-1 downto 0);
  signal m_axi4_bvalid       : std_logic;
  signal m_axi4_bready       : std_logic;
  signal m_axi4_arid         : std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
  signal m_axi4_araddr       : std_logic_vector(C_M_AXI4_ADDR_WIDTH-1 downto 0);
  signal m_axi4_arlen        : std_logic_vector(7 downto 0) := (others => '0');
  signal m_axi4_arsize       : std_logic_vector(2 downto 0);
  signal m_axi4_arburst      : std_logic_vector(1 downto 0);
  signal m_axi4_arlock       : std_logic;
  signal m_axi4_arcache      : std_logic_vector(3 downto 0);
  signal m_axi4_arprot       : std_logic_vector(2 downto 0);
  signal m_axi4_arqos        : std_logic_vector(3 downto 0);
  signal m_axi4_aruser       : std_logic_vector(C_M_AXI4_ARUSER_WIDTH-1 downto 0);
  signal m_axi4_arvalid      : std_logic;
  signal m_axi4_arready      : std_logic;
  signal m_axi4_rid          : std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
  signal m_axi4_rdata        : std_logic_vector(C_M_AXI4_DATA_WIDTH-1 downto 0);
  signal m_axi4_rresp        : std_logic_vector(1 downto 0);
  signal m_axi4_rlast        : std_logic;
  signal m_axi4_ruser        : std_logic_vector(C_M_AXI4_RUSER_WIDTH-1 downto 0);
  signal m_axi4_rvalid       : std_logic;
  signal m_axi4_rready       : std_logic;

begin

  uut : entity work.WishboneAXI_v0_1 generic map (
    C_AXI_PROT                           => "AXI4LITE",
    C_S_WB_ADR_WIDTH                     => C_S_WB_ADR_WIDTH,
    C_S_WB_DAT_WIDTH                     => C_S_WB_DAT_WIDTH,
    C_M_WB_ADR_WIDTH                     => C_M_WB_ADR_WIDTH,
    C_M_WB_DAT_WIDTH                     => C_M_WB_DAT_WIDTH,
    C_S_AXI4_LITE_DATA_WIDTH             => C_S_AXI4_LITE_DATA_WIDTH,
    C_S_AXI4_LITE_ADDR_WIDTH             => C_S_AXI4_LITE_ADDR_WIDTH,
    C_S_AXI4_ID_WIDTH                    => C_S_AXI4_ID_WIDTH,
    C_S_AXI4_DATA_WIDTH                  => C_S_AXI4_DATA_WIDTH,
    C_S_AXI4_ADDR_WIDTH                  => C_S_AXI4_ADDR_WIDTH,
    C_S_AXI4_AWUSER_WIDTH                => C_S_AXI4_AWUSER_WIDTH,
    C_S_AXI4_ARUSER_WIDTH                => C_S_AXI4_ARUSER_WIDTH,
    C_S_AXI4_WUSER_WIDTH                 => C_S_AXI4_WUSER_WIDTH,
    C_S_AXI4_RUSER_WIDTH                 => C_S_AXI4_RUSER_WIDTH,
    C_S_AXI4_BUSER_WIDTH                 => C_S_AXI4_BUSER_WIDTH,
    C_M_AXI4_LITE_START_DATA_VALUE       => x"01234567",
    C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR => x"00001000",
    C_M_AXI4_LITE_ADDR_WIDTH             => C_M_AXI4_LITE_ADDR_WIDTH,
    C_M_AXI4_LITE_DATA_WIDTH             => C_M_AXI4_LITE_DATA_WIDTH,
    C_M_AXI4_LITE_TRANSACTIONS_NUM       => 1,
    C_M_AXI4_TARGET_SLAVE_BASE_ADDR      => x"10000000",
    C_M_AXI4_BURST_LEN                   => C_M_AXI4_BURST_LEN,
    C_M_AXI4_ID_WIDTH                    => C_M_AXI4_ID_WIDTH,
    C_M_AXI4_ADDR_WIDTH                  => C_M_AXI4_ADDR_WIDTH,
    C_M_AXI4_DATA_WIDTH                  => C_M_AXI4_DATA_WIDTH,
    C_M_AXI4_AWUSER_WIDTH                => C_M_AXI4_AWUSER_WIDTH,
    C_M_AXI4_ARUSER_WIDTH                => C_M_AXI4_ARUSER_WIDTH,
    C_M_AXI4_WUSER_WIDTH                 => C_M_AXI4_WUSER_WIDTH,
    C_M_AXI4_RUSER_WIDTH                 => C_M_AXI4_RUSER_WIDTH,
    C_M_AXI4_BUSER_WIDTH                 => C_M_AXI4_BUSER_WIDTH)
    port map (
      s_wb_aclk           => s_wb_aclk,
      s_wb_aresetn        => s_wb_aresetn,
      s_wb_adr            => s_wb_adr,
      s_wb_dat_w          => s_wb_dat_w,
      s_wb_cyc            => s_wb_cyc,
      s_wb_stb            => s_wb_stb,
      s_wb_lock           => s_wb_lock,
      s_wb_sel            => s_wb_sel,
      s_wb_we             => s_wb_we,
      s_wb_dat_r          => s_wb_dat_r,
      s_wb_stall          => s_wb_stall,
      s_wb_err            => s_wb_err,
      s_wb_rty            => s_wb_rty,
      s_wb_ack            => s_wb_ack,
      m_wb_aclk           => m_wb_aclk,
      m_wb_aresetn        => m_wb_aresetn,
      m_wb_adr            => m_wb_adr,
      m_wb_dat_w          => m_wb_dat_w,
      m_wb_cyc            => m_wb_cyc,
      m_wb_stb            => m_wb_stb,
      m_wb_lock           => m_wb_lock,
      m_wb_sel            => m_wb_sel,
      m_wb_we             => m_wb_we,
      m_wb_dat_r          => m_wb_dat_r,
      m_wb_stall          => m_wb_stall,
      m_wb_err            => m_wb_err,
      m_wb_rty            => m_wb_rty,
      m_wb_ack            => m_wb_ack,
      s_axi4_lite_aclk    => s_axi4_lite_aclk,
      s_axi4_lite_aresetn => s_axi4_lite_aresetn,
      s_axi4_lite_awaddr  => s_axi4_lite_awaddr,
      s_axi4_lite_awprot  => s_axi4_lite_awprot,
      s_axi4_lite_awvalid => s_axi4_lite_awvalid,
      s_axi4_lite_awready => s_axi4_lite_awready,
      s_axi4_lite_wdata   => s_axi4_lite_wdata,
      s_axi4_lite_wstrb   => s_axi4_lite_wstrb,
      s_axi4_lite_wvalid  => s_axi4_lite_wvalid,
      s_axi4_lite_wready  => s_axi4_lite_wready,
      s_axi4_lite_bresp   => s_axi4_lite_bresp,
      s_axi4_lite_bvalid  => s_axi4_lite_bvalid,
      s_axi4_lite_bready  => s_axi4_lite_bready,
      s_axi4_lite_araddr  => s_axi4_lite_araddr,
      s_axi4_lite_arprot  => s_axi4_lite_arprot,
      s_axi4_lite_arvalid => s_axi4_lite_arvalid,
      s_axi4_lite_arready => s_axi4_lite_arready,
      s_axi4_lite_rdata   => s_axi4_lite_rdata,
      s_axi4_lite_rresp   => s_axi4_lite_rresp,
      s_axi4_lite_rvalid  => s_axi4_lite_rvalid,
      s_axi4_lite_rready  => s_axi4_lite_rready,
      s_axi4_aclk         => s_axi4_aclk,
      s_axi4_aresetn      => s_axi4_aresetn,
      s_axi4_awid         => s_axi4_awid,
      s_axi4_awaddr       => s_axi4_awaddr,
      s_axi4_awlen        => s_axi4_awlen,
      s_axi4_awsize       => s_axi4_awsize,
      s_axi4_awburst      => s_axi4_awburst,
      s_axi4_awlock       => s_axi4_awlock,
      s_axi4_awcache      => s_axi4_awcache,
      s_axi4_awprot       => s_axi4_awprot,
      s_axi4_awqos        => s_axi4_awqos,
      s_axi4_awregion     => s_axi4_awregion,
      s_axi4_awuser       => s_axi4_awuser,
      s_axi4_awvalid      => s_axi4_awvalid,
      s_axi4_awready      => s_axi4_awready,
      s_axi4_wdata        => s_axi4_wdata,
      s_axi4_wstrb        => s_axi4_wstrb,
      s_axi4_wlast        => s_axi4_wlast,
      s_axi4_wuser        => s_axi4_wuser,
      s_axi4_wvalid       => s_axi4_wvalid,
      s_axi4_wready       => s_axi4_wready,
      s_axi4_bid          => s_axi4_bid,
      s_axi4_bresp        => s_axi4_bresp,
      s_axi4_buser        => s_axi4_buser,
      s_axi4_bvalid       => s_axi4_bvalid,
      s_axi4_bready       => s_axi4_bready,
      s_axi4_arid         => s_axi4_arid,
      s_axi4_araddr       => s_axi4_araddr,
      s_axi4_arlen        => s_axi4_arlen,
      s_axi4_arsize       => s_axi4_arsize,
      s_axi4_arburst      => s_axi4_arburst,
      s_axi4_arlock       => s_axi4_arlock,
      s_axi4_arcache      => s_axi4_arcache,
      s_axi4_arprot       => s_axi4_arprot,
      s_axi4_arqos        => s_axi4_arqos,
      s_axi4_arregion     => s_axi4_arregion,
      s_axi4_aruser       => s_axi4_aruser,
      s_axi4_arvalid      => s_axi4_arvalid,
      s_axi4_arready      => s_axi4_arready,
      s_axi4_rid          => s_axi4_rid,
      s_axi4_rdata        => s_axi4_rdata,
      s_axi4_rresp        => s_axi4_rresp,
      s_axi4_rlast        => s_axi4_rlast,
      s_axi4_ruser        => s_axi4_ruser,
      s_axi4_rvalid       => s_axi4_rvalid,
      s_axi4_rready       => s_axi4_rready,
      m_axi4_lite_aclk    => m_axi4_lite_aclk,
      m_axi4_lite_aresetn => m_axi4_lite_aresetn,
      m_axi4_lite_awaddr  => m_axi4_lite_awaddr,
      m_axi4_lite_awprot  => m_axi4_lite_awprot,
      m_axi4_lite_awvalid => m_axi4_lite_awvalid,
      m_axi4_lite_awready => m_axi4_lite_awready,
      m_axi4_lite_wdata   => m_axi4_lite_wdata,
      m_axi4_lite_wstrb   => m_axi4_lite_wstrb,
      m_axi4_lite_wvalid  => m_axi4_lite_wvalid,
      m_axi4_lite_wready  => m_axi4_lite_wready,
      m_axi4_lite_bresp   => m_axi4_lite_bresp,
      m_axi4_lite_bvalid  => m_axi4_lite_bvalid,
      m_axi4_lite_bready  => m_axi4_lite_bready,
      m_axi4_lite_araddr  => m_axi4_lite_araddr,
      m_axi4_lite_arprot  => m_axi4_lite_arprot,
      m_axi4_lite_arvalid => m_axi4_lite_arvalid,
      m_axi4_lite_arready => m_axi4_lite_arready,
      m_axi4_lite_rdata   => m_axi4_lite_rdata,
      m_axi4_lite_rresp   => m_axi4_lite_rresp,
      m_axi4_lite_rvalid  => m_axi4_lite_rvalid,
      m_axi4_lite_rready  => m_axi4_lite_rready,
      m_axi4_aclk         => m_axi4_aclk,
      m_axi4_aresetn      => m_axi4_aresetn,
      m_axi4_awid         => m_axi4_awid,
      m_axi4_awaddr       => m_axi4_awaddr,
      m_axi4_awlen        => m_axi4_awlen,
      m_axi4_awsize       => m_axi4_awsize,
      m_axi4_awburst      => m_axi4_awburst,
      m_axi4_awlock       => m_axi4_awlock,
      m_axi4_awcache      => m_axi4_awcache,
      m_axi4_awprot       => m_axi4_awprot,
      m_axi4_awqos        => m_axi4_awqos,
      m_axi4_awuser       => m_axi4_awuser,
      m_axi4_awvalid      => m_axi4_awvalid,
      m_axi4_awready      => m_axi4_awready,
      m_axi4_wdata        => m_axi4_wdata,
      m_axi4_wstrb        => m_axi4_wstrb,
      m_axi4_wlast        => m_axi4_wlast,
      m_axi4_wuser        => m_axi4_wuser,
      m_axi4_wvalid       => m_axi4_wvalid,
      m_axi4_wready       => m_axi4_wready,
      m_axi4_bid          => m_axi4_bid,
      m_axi4_bresp        => m_axi4_bresp,
      m_axi4_buser        => m_axi4_buser,
      m_axi4_bvalid       => m_axi4_bvalid,
      m_axi4_bready       => m_axi4_bready,
      m_axi4_arid         => m_axi4_arid,
      m_axi4_araddr       => m_axi4_araddr,
      m_axi4_arlen        => m_axi4_arlen,
      m_axi4_arsize       => m_axi4_arsize,
      m_axi4_arburst      => m_axi4_arburst,
      m_axi4_arlock       => m_axi4_arlock,
      m_axi4_arcache      => m_axi4_arcache,
      m_axi4_arprot       => m_axi4_arprot,
      m_axi4_arqos        => m_axi4_arqos,
      m_axi4_aruser       => m_axi4_aruser,
      m_axi4_arvalid      => m_axi4_arvalid,
      m_axi4_arready      => m_axi4_arready,
      m_axi4_rid          => m_axi4_rid,
      m_axi4_rdata        => m_axi4_rdata,
      m_axi4_rresp        => m_axi4_rresp,
      m_axi4_rlast        => m_axi4_rlast,
      m_axi4_ruser        => m_axi4_ruser,
      m_axi4_rvalid       => m_axi4_rvalid,
      m_axi4_rready       => m_axi4_rready
      );

  stimulus : process
  begin

    -- Put initialisation code here


    -- Put test bench stimulus code here

    wait;
  end process;


end;

