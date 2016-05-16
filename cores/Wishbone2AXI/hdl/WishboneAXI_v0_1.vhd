library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WishboneAXI_v0_1 is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line

    -- Parameters of Axi Slave Bus Interface S_AXI4_LITE
    C_S_AXI4_LITE_DATA_WIDTH : integer := 32;
    C_S_AXI4_LITE_ADDR_WIDTH : integer := 4;

    -- Parameters of Axi Slave Bus Interface S_AXI4
    C_S_AXI4_ID_WIDTH     : integer := 1;
    C_S_AXI4_DATA_WIDTH   : integer := 32;
    C_S_AXI4_ADDR_WIDTH   : integer := 6;
    C_S_AXI4_AWUSER_WIDTH : integer := 0;
    C_S_AXI4_ARUSER_WIDTH : integer := 0;
    C_S_AXI4_WUSER_WIDTH  : integer := 0;
    C_S_AXI4_RUSER_WIDTH  : integer := 0;
    C_S_AXI4_BUSER_WIDTH  : integer := 0;

    -- Parameters of Axi Master Bus Interface M_AXI4_LITE
    C_M_AXI4_LITE_START_DATA_VALUE       : std_logic_vector := x"AA000000";
    C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR : std_logic_vector := x"40000000";
    C_M_AXI4_LITE_ADDR_WIDTH             : integer          := 32;
    C_M_AXI4_LITE_DATA_WIDTH             : integer          := 32;
    C_M_AXI4_LITE_TRANSACTIONS_NUM       : integer          := 4;

    -- Parameters of Axi Master Bus Interface M_AXI4
    C_M_AXI4_TARGET_SLAVE_BASE_ADDR : std_logic_vector := x"40000000";
    C_M_AXI4_BURST_LEN              : integer          := 16;
    C_M_AXI4_ID_WIDTH               : integer          := 1;
    C_M_AXI4_ADDR_WIDTH             : integer          := 32;
    C_M_AXI4_DATA_WIDTH             : integer          := 32;
    C_M_AXI4_AWUSER_WIDTH           : integer          := 0;
    C_M_AXI4_ARUSER_WIDTH           : integer          := 0;
    C_M_AXI4_WUSER_WIDTH            : integer          := 0;
    C_M_AXI4_RUSER_WIDTH            : integer          := 0;
    C_M_AXI4_BUSER_WIDTH            : integer          := 0;


    C_S_WB_ADR_WIDTH  : integer := 32;
    C_S_WB_DATW_WIDTH : integer := 32;
    C_S_WB_DATR_WIDTH : integer := 32;

    C_M_WB_ADR_WIDTH  : integer := 32;
    C_M_WB_DATW_WIDTH : integer := 32;
    C_M_WB_DATR_WIDTH : integer := 32
    );
  port (
    -- Users to add ports here
    s_wb_aclk    : in  std_logic;
    s_wb_aresetn : in  std_logic;
    s_wb_adr     : in  std_logic_vector(C_S_WB_ADR_WIDTH-1 downto 0);
    s_wb_dat_w   : in  std_logic_vector(C_S_WB_DATW_WIDTH-1 downto 0);
    s_wb_cyc     : in  std_logic;
    s_wb_stb     : in  std_logic;
    s_wb_lock    : in  std_logic;
    s_wb_sel     : in  std_logic_vector(3 downto 0);
    s_wb_we      : in  std_logic;
    s_wb_dat_r   : out std_logic_vector(C_S_WB_DATR_WIDTH-1 downto 0);
    s_wb_stall   : out std_logic;
    s_wb_err     : out std_logic;
    s_wb_rty     : out std_logic;
    s_wb_ack     : out std_logic;

    m_wb_aclk    : in  std_logic;
    m_wb_aresetn : in  std_logic;
    m_wb_adr     : out std_logic_vector(C_M_WB_ADR_WIDTH-1 downto 0);
    m_wb_dat_w   : out std_logic_vector(C_M_WB_DATW_WIDTH-1 downto 0);
    m_wb_cyc     : out std_logic;
    m_wb_stb     : out std_logic;
    m_wb_lock    : out std_logic;
    m_wb_sel     : out std_logic_vector(3 downto 0);
    m_wb_we      : out std_logic;
    m_wb_dat_r   : in  std_logic_vector(C_M_WB_DATR_WIDTH-1 downto 0);
    m_wb_stall   : in  std_logic;
    m_wb_err     : in  std_logic;
    m_wb_rty     : in  std_logic;
    m_wb_ack     : in  std_logic;
    -- User ports ends
    -- Do not modify the ports beyond this line


    -- Ports of Axi Slave Bus Interface S_AXI4_LITE
    s_axi4_lite_aclk    : in  std_logic;
    s_axi4_lite_aresetn : in  std_logic;
    s_axi4_lite_awaddr  : in  std_logic_vector(C_S_AXI4_LITE_ADDR_WIDTH-1 downto 0);
    s_axi4_lite_awprot  : in  std_logic_vector(2 downto 0);
    s_axi4_lite_awvalid : in  std_logic;
    s_axi4_lite_awready : out std_logic;
    s_axi4_lite_wdata   : in  std_logic_vector(C_S_AXI4_LITE_DATA_WIDTH-1 downto 0);
    s_axi4_lite_wstrb   : in  std_logic_vector((C_S_AXI4_LITE_DATA_WIDTH/8)-1 downto 0);
    s_axi4_lite_wvalid  : in  std_logic;
    s_axi4_lite_wready  : out std_logic;
    s_axi4_lite_bresp   : out std_logic_vector(1 downto 0);
    s_axi4_lite_bvalid  : out std_logic;
    s_axi4_lite_bready  : in  std_logic;
    s_axi4_lite_araddr  : in  std_logic_vector(C_S_AXI4_LITE_ADDR_WIDTH-1 downto 0);
    s_axi4_lite_arprot  : in  std_logic_vector(2 downto 0);
    s_axi4_lite_arvalid : in  std_logic;
    s_axi4_lite_arready : out std_logic;
    s_axi4_lite_rdata   : out std_logic_vector(C_S_AXI4_LITE_DATA_WIDTH-1 downto 0);
    s_axi4_lite_rresp   : out std_logic_vector(1 downto 0);
    s_axi4_lite_rvalid  : out std_logic;
    s_axi4_lite_rready  : in  std_logic;

    -- Ports of Axi Slave Bus Interface S_AXI4
    s_axi4_aclk     : in  std_logic;
    s_axi4_aresetn  : in  std_logic;
    s_axi4_awid     : in  std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
    s_axi4_awaddr   : in  std_logic_vector(C_S_AXI4_ADDR_WIDTH-1 downto 0);
    s_axi4_awlen    : in  std_logic_vector(7 downto 0);
    s_axi4_awsize   : in  std_logic_vector(2 downto 0);
    s_axi4_awburst  : in  std_logic_vector(1 downto 0);
    s_axi4_awlock   : in  std_logic;
    s_axi4_awcache  : in  std_logic_vector(3 downto 0);
    s_axi4_awprot   : in  std_logic_vector(2 downto 0);
    s_axi4_awqos    : in  std_logic_vector(3 downto 0);
    s_axi4_awregion : in  std_logic_vector(3 downto 0);
    s_axi4_awuser   : in  std_logic_vector(C_S_AXI4_AWUSER_WIDTH-1 downto 0);
    s_axi4_awvalid  : in  std_logic;
    s_axi4_awready  : out std_logic;
    s_axi4_wdata    : in  std_logic_vector(C_S_AXI4_DATA_WIDTH-1 downto 0);
    s_axi4_wstrb    : in  std_logic_vector((C_S_AXI4_DATA_WIDTH/8)-1 downto 0);
    s_axi4_wlast    : in  std_logic;
    s_axi4_wuser    : in  std_logic_vector(C_S_AXI4_WUSER_WIDTH-1 downto 0);
    s_axi4_wvalid   : in  std_logic;
    s_axi4_wready   : out std_logic;
    s_axi4_bid      : out std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
    s_axi4_bresp    : out std_logic_vector(1 downto 0);
    s_axi4_buser    : out std_logic_vector(C_S_AXI4_BUSER_WIDTH-1 downto 0);
    s_axi4_bvalid   : out std_logic;
    s_axi4_bready   : in  std_logic;
    s_axi4_arid     : in  std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
    s_axi4_araddr   : in  std_logic_vector(C_S_AXI4_ADDR_WIDTH-1 downto 0);
    s_axi4_arlen    : in  std_logic_vector(7 downto 0);
    s_axi4_arsize   : in  std_logic_vector(2 downto 0);
    s_axi4_arburst  : in  std_logic_vector(1 downto 0);
    s_axi4_arlock   : in  std_logic;
    s_axi4_arcache  : in  std_logic_vector(3 downto 0);
    s_axi4_arprot   : in  std_logic_vector(2 downto 0);
    s_axi4_arqos    : in  std_logic_vector(3 downto 0);
    s_axi4_arregion : in  std_logic_vector(3 downto 0);
    s_axi4_aruser   : in  std_logic_vector(C_S_AXI4_ARUSER_WIDTH-1 downto 0);
    s_axi4_arvalid  : in  std_logic;
    s_axi4_arready  : out std_logic;
    s_axi4_rid      : out std_logic_vector(C_S_AXI4_ID_WIDTH-1 downto 0);
    s_axi4_rdata    : out std_logic_vector(C_S_AXI4_DATA_WIDTH-1 downto 0);
    s_axi4_rresp    : out std_logic_vector(1 downto 0);
    s_axi4_rlast    : out std_logic;
    s_axi4_ruser    : out std_logic_vector(C_S_AXI4_RUSER_WIDTH-1 downto 0);
    s_axi4_rvalid   : out std_logic;
    s_axi4_rready   : in  std_logic;

    -- Ports of Axi Master Bus Interface M_AXI4_LITE
    m_axi4_lite_aclk    : in  std_logic;
    m_axi4_lite_aresetn : in  std_logic;
    m_axi4_lite_awaddr  : out std_logic_vector(C_M_AXI4_LITE_ADDR_WIDTH-1 downto 0);
    m_axi4_lite_awprot  : out std_logic_vector(2 downto 0);
    m_axi4_lite_awvalid : out std_logic;
    m_axi4_lite_awready : in  std_logic;
    m_axi4_lite_wdata   : out std_logic_vector(C_M_AXI4_LITE_DATA_WIDTH-1 downto 0);
    m_axi4_lite_wstrb   : out std_logic_vector(C_M_AXI4_LITE_DATA_WIDTH/8-1 downto 0);
    m_axi4_lite_wvalid  : out std_logic;
    m_axi4_lite_wready  : in  std_logic;
    m_axi4_lite_bresp   : in  std_logic_vector(1 downto 0);
    m_axi4_lite_bvalid  : in  std_logic;
    m_axi4_lite_bready  : out std_logic;
    m_axi4_lite_araddr  : out std_logic_vector(C_M_AXI4_LITE_ADDR_WIDTH-1 downto 0);
    m_axi4_lite_arprot  : out std_logic_vector(2 downto 0);
    m_axi4_lite_arvalid : out std_logic;
    m_axi4_lite_arready : in  std_logic;
    m_axi4_lite_rdata   : in  std_logic_vector(C_M_AXI4_LITE_DATA_WIDTH-1 downto 0);
    m_axi4_lite_rresp   : in  std_logic_vector(1 downto 0);
    m_axi4_lite_rvalid  : in  std_logic;
    m_axi4_lite_rready  : out std_logic;

    -- Ports of Axi Master Bus Interface M_AXI4
    m_axi4_aclk    : in  std_logic;
    m_axi4_aresetn : in  std_logic;
    m_axi4_awid    : out std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
    m_axi4_awaddr  : out std_logic_vector(C_M_AXI4_ADDR_WIDTH-1 downto 0);
    m_axi4_awlen   : out std_logic_vector(7 downto 0);
    m_axi4_awsize  : out std_logic_vector(2 downto 0);
    m_axi4_awburst : out std_logic_vector(1 downto 0);
    m_axi4_awlock  : out std_logic;
    m_axi4_awcache : out std_logic_vector(3 downto 0);
    m_axi4_awprot  : out std_logic_vector(2 downto 0);
    m_axi4_awqos   : out std_logic_vector(3 downto 0);
    m_axi4_awuser  : out std_logic_vector(C_M_AXI4_AWUSER_WIDTH-1 downto 0);
    m_axi4_awvalid : out std_logic;
    m_axi4_awready : in  std_logic;
    m_axi4_wdata   : out std_logic_vector(C_M_AXI4_DATA_WIDTH-1 downto 0);
    m_axi4_wstrb   : out std_logic_vector(C_M_AXI4_DATA_WIDTH/8-1 downto 0);
    m_axi4_wlast   : out std_logic;
    m_axi4_wuser   : out std_logic_vector(C_M_AXI4_WUSER_WIDTH-1 downto 0);
    m_axi4_wvalid  : out std_logic;
    m_axi4_wready  : in  std_logic;
    m_axi4_bid     : in  std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
    m_axi4_bresp   : in  std_logic_vector(1 downto 0);
    m_axi4_buser   : in  std_logic_vector(C_M_AXI4_BUSER_WIDTH-1 downto 0);
    m_axi4_bvalid  : in  std_logic;
    m_axi4_bready  : out std_logic;
    m_axi4_arid    : out std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
    m_axi4_araddr  : out std_logic_vector(C_M_AXI4_ADDR_WIDTH-1 downto 0);
    m_axi4_arlen   : out std_logic_vector(7 downto 0);
    m_axi4_arsize  : out std_logic_vector(2 downto 0);
    m_axi4_arburst : out std_logic_vector(1 downto 0);
    m_axi4_arlock  : out std_logic;
    m_axi4_arcache : out std_logic_vector(3 downto 0);
    m_axi4_arprot  : out std_logic_vector(2 downto 0);
    m_axi4_arqos   : out std_logic_vector(3 downto 0);
    m_axi4_aruser  : out std_logic_vector(C_M_AXI4_ARUSER_WIDTH-1 downto 0);
    m_axi4_arvalid : out std_logic;
    m_axi4_arready : in  std_logic;
    m_axi4_rid     : in  std_logic_vector(C_M_AXI4_ID_WIDTH-1 downto 0);
    m_axi4_rdata   : in  std_logic_vector(C_M_AXI4_DATA_WIDTH-1 downto 0);
    m_axi4_rresp   : in  std_logic_vector(1 downto 0);
    m_axi4_rlast   : in  std_logic;
    m_axi4_ruser   : in  std_logic_vector(C_M_AXI4_RUSER_WIDTH-1 downto 0);
    m_axi4_rvalid  : in  std_logic;
    m_axi4_rready  : out std_logic
    );
end WishboneAXI_v0_1;

architecture arch_imp of WishboneAXI_v0_1 is

  -- component declaration
  component WishboneAXI_v0_1_S_AXI4_LITE is
    generic (
      C_S_AXI_DATA_WIDTH : integer := 32;
      C_S_AXI_ADDR_WIDTH : integer := 4
      );
    port (
      S_AXI_ACLK    : in  std_logic;
      S_AXI_ARESETN : in  std_logic;
      S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
      S_AXI_AWVALID : in  std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WVALID  : in  std_logic;
      S_AXI_WREADY  : out std_logic;
      S_AXI_BRESP   : out std_logic_vector(1 downto 0);
      S_AXI_BVALID  : out std_logic;
      S_AXI_BREADY  : in  std_logic;
      S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
      S_AXI_ARVALID : in  std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP   : out std_logic_vector(1 downto 0);
      S_AXI_RVALID  : out std_logic;
      S_AXI_RREADY  : in  std_logic
      );
  end component WishboneAXI_v0_1_S_AXI4_LITE;

  component WishboneAXI_v0_1_S_AXI4 is
    generic (
      C_S_AXI_ID_WIDTH     : integer := 1;
      C_S_AXI_DATA_WIDTH   : integer := 32;
      C_S_AXI_ADDR_WIDTH   : integer := 6;
      C_S_AXI_AWUSER_WIDTH : integer := 0;
      C_S_AXI_ARUSER_WIDTH : integer := 0;
      C_S_AXI_WUSER_WIDTH  : integer := 0;
      C_S_AXI_RUSER_WIDTH  : integer := 0;
      C_S_AXI_BUSER_WIDTH  : integer := 0
      );
    port (
      S_AXI_ACLK     : in  std_logic;
      S_AXI_ARESETN  : in  std_logic;
      S_AXI_AWID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_AWADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_AWLEN    : in  std_logic_vector(7 downto 0);
      S_AXI_AWSIZE   : in  std_logic_vector(2 downto 0);
      S_AXI_AWBURST  : in  std_logic_vector(1 downto 0);
      S_AXI_AWLOCK   : in  std_logic;
      S_AXI_AWCACHE  : in  std_logic_vector(3 downto 0);
      S_AXI_AWPROT   : in  std_logic_vector(2 downto 0);
      S_AXI_AWQOS    : in  std_logic_vector(3 downto 0);
      S_AXI_AWREGION : in  std_logic_vector(3 downto 0);
      S_AXI_AWUSER   : in  std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
      S_AXI_AWVALID  : in  std_logic;
      S_AXI_AWREADY  : out std_logic;
      S_AXI_WDATA    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WLAST    : in  std_logic;
      S_AXI_WUSER    : in  std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
      S_AXI_WVALID   : in  std_logic;
      S_AXI_WREADY   : out std_logic;
      S_AXI_BID      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_BRESP    : out std_logic_vector(1 downto 0);
      S_AXI_BUSER    : out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
      S_AXI_BVALID   : out std_logic;
      S_AXI_BREADY   : in  std_logic;
      S_AXI_ARID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_ARADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_ARLEN    : in  std_logic_vector(7 downto 0);
      S_AXI_ARSIZE   : in  std_logic_vector(2 downto 0);
      S_AXI_ARBURST  : in  std_logic_vector(1 downto 0);
      S_AXI_ARLOCK   : in  std_logic;
      S_AXI_ARCACHE  : in  std_logic_vector(3 downto 0);
      S_AXI_ARPROT   : in  std_logic_vector(2 downto 0);
      S_AXI_ARQOS    : in  std_logic_vector(3 downto 0);
      S_AXI_ARREGION : in  std_logic_vector(3 downto 0);
      S_AXI_ARUSER   : in  std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
      S_AXI_ARVALID  : in  std_logic;
      S_AXI_ARREADY  : out std_logic;
      S_AXI_RID      : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      S_AXI_RDATA    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP    : out std_logic_vector(1 downto 0);
      S_AXI_RLAST    : out std_logic;
      S_AXI_RUSER    : out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
      S_AXI_RVALID   : out std_logic;
      S_AXI_RREADY   : in  std_logic
      );
  end component WishboneAXI_v0_1_S_AXI4;

  component WishboneAXI_v0_1_M_AXI4_LITE is
    generic (
      C_M_START_DATA_VALUE       : std_logic_vector := x"AA000000";
      C_M_TARGET_SLAVE_BASE_ADDR : std_logic_vector := x"40000000";
      C_M_AXI_ADDR_WIDTH         : integer          := 32;
      C_M_AXI_DATA_WIDTH         : integer          := 32;
      C_M_TRANSACTIONS_NUM       : integer          := 4
      );
    port (
      INIT_AXI_TXN  : in  std_logic;
      error         : out std_logic;
      TXN_DONE      : out std_logic;
      M_AXI_ACLK    : in  std_logic;
      M_AXI_ARESETN : in  std_logic;
      M_AXI_AWADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_AWPROT  : out std_logic_vector(2 downto 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in  std_logic;
      M_AXI_WDATA   : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_WSTRB   : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
      M_AXI_WVALID  : out std_logic;
      M_AXI_WREADY  : in  std_logic;
      M_AXI_BRESP   : in  std_logic_vector(1 downto 0);
      M_AXI_BVALID  : in  std_logic;
      M_AXI_BREADY  : out std_logic;
      M_AXI_ARADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_ARPROT  : out std_logic_vector(2 downto 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in  std_logic;
      M_AXI_RDATA   : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_RRESP   : in  std_logic_vector(1 downto 0);
      M_AXI_RVALID  : in  std_logic;
      M_AXI_RREADY  : out std_logic
      );
  end component WishboneAXI_v0_1_M_AXI4_LITE;

  component WishboneAXI_v0_1_M_AXI4 is
    generic (
      C_M_TARGET_SLAVE_BASE_ADDR : std_logic_vector := x"40000000";
      C_M_AXI_BURST_LEN          : integer          := 16;
      C_M_AXI_ID_WIDTH           : integer          := 1;
      C_M_AXI_ADDR_WIDTH         : integer          := 32;
      C_M_AXI_DATA_WIDTH         : integer          := 32;
      C_M_AXI_AWUSER_WIDTH       : integer          := 0;
      C_M_AXI_ARUSER_WIDTH       : integer          := 0;
      C_M_AXI_WUSER_WIDTH        : integer          := 0;
      C_M_AXI_RUSER_WIDTH        : integer          := 0;
      C_M_AXI_BUSER_WIDTH        : integer          := 0
      );
    port (
      INIT_AXI_TXN  : in  std_logic;
      TXN_DONE      : out std_logic;
      error         : out std_logic;
      M_AXI_ACLK    : in  std_logic;
      M_AXI_ARESETN : in  std_logic;
      M_AXI_AWID    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_AWADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_AWLEN   : out std_logic_vector(7 downto 0);
      M_AXI_AWSIZE  : out std_logic_vector(2 downto 0);
      M_AXI_AWBURST : out std_logic_vector(1 downto 0);
      M_AXI_AWLOCK  : out std_logic;
      M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
      M_AXI_AWPROT  : out std_logic_vector(2 downto 0);
      M_AXI_AWQOS   : out std_logic_vector(3 downto 0);
      M_AXI_AWUSER  : out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in  std_logic;
      M_AXI_WDATA   : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_WSTRB   : out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
      M_AXI_WLAST   : out std_logic;
      M_AXI_WUSER   : out std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
      M_AXI_WVALID  : out std_logic;
      M_AXI_WREADY  : in  std_logic;
      M_AXI_BID     : in  std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_BRESP   : in  std_logic_vector(1 downto 0);
      M_AXI_BUSER   : in  std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
      M_AXI_BVALID  : in  std_logic;
      M_AXI_BREADY  : out std_logic;
      M_AXI_ARID    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_ARADDR  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
      M_AXI_ARLEN   : out std_logic_vector(7 downto 0);
      M_AXI_ARSIZE  : out std_logic_vector(2 downto 0);
      M_AXI_ARBURST : out std_logic_vector(1 downto 0);
      M_AXI_ARLOCK  : out std_logic;
      M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
      M_AXI_ARPROT  : out std_logic_vector(2 downto 0);
      M_AXI_ARQOS   : out std_logic_vector(3 downto 0);
      M_AXI_ARUSER  : out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in  std_logic;
      M_AXI_RID     : in  std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
      M_AXI_RDATA   : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
      M_AXI_RRESP   : in  std_logic_vector(1 downto 0);
      M_AXI_RLAST   : in  std_logic;
      M_AXI_RUSER   : in  std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
      M_AXI_RVALID  : in  std_logic;
      M_AXI_RREADY  : out std_logic
      );
  end component WishboneAXI_v0_1_M_AXI4;

begin

-- Instantiation of Axi Bus Interface S_AXI4_LITE
  WishboneAXI_v0_1_S_AXI4_LITE_inst : WishboneAXI_v0_1_S_AXI4_LITE
    generic map (
      C_S_AXI_DATA_WIDTH => C_S_AXI4_LITE_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_S_AXI4_LITE_ADDR_WIDTH
      )
    port map (
      S_AXI_ACLK    => s_axi4_lite_aclk,
      S_AXI_ARESETN => s_axi4_lite_aresetn,
      S_AXI_AWADDR  => s_axi4_lite_awaddr,
      S_AXI_AWPROT  => s_axi4_lite_awprot,
      S_AXI_AWVALID => s_axi4_lite_awvalid,
      S_AXI_AWREADY => s_axi4_lite_awready,
      S_AXI_WDATA   => s_axi4_lite_wdata,
      S_AXI_WSTRB   => s_axi4_lite_wstrb,
      S_AXI_WVALID  => s_axi4_lite_wvalid,
      S_AXI_WREADY  => s_axi4_lite_wready,
      S_AXI_BRESP   => s_axi4_lite_bresp,
      S_AXI_BVALID  => s_axi4_lite_bvalid,
      S_AXI_BREADY  => s_axi4_lite_bready,
      S_AXI_ARADDR  => s_axi4_lite_araddr,
      S_AXI_ARPROT  => s_axi4_lite_arprot,
      S_AXI_ARVALID => s_axi4_lite_arvalid,
      S_AXI_ARREADY => s_axi4_lite_arready,
      S_AXI_RDATA   => s_axi4_lite_rdata,
      S_AXI_RRESP   => s_axi4_lite_rresp,
      S_AXI_RVALID  => s_axi4_lite_rvalid,
      S_AXI_RREADY  => s_axi4_lite_rready
      );

-- Instantiation of Axi Bus Interface S_AXI4
  WishboneAXI_v0_1_S_AXI4_inst : WishboneAXI_v0_1_S_AXI4
    generic map (
      C_S_AXI_ID_WIDTH     => C_S_AXI4_ID_WIDTH,
      C_S_AXI_DATA_WIDTH   => C_S_AXI4_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH   => C_S_AXI4_ADDR_WIDTH,
      C_S_AXI_AWUSER_WIDTH => C_S_AXI4_AWUSER_WIDTH,
      C_S_AXI_ARUSER_WIDTH => C_S_AXI4_ARUSER_WIDTH,
      C_S_AXI_WUSER_WIDTH  => C_S_AXI4_WUSER_WIDTH,
      C_S_AXI_RUSER_WIDTH  => C_S_AXI4_RUSER_WIDTH,
      C_S_AXI_BUSER_WIDTH  => C_S_AXI4_BUSER_WIDTH
      )
    port map (
      S_AXI_ACLK     => s_axi4_aclk,
      S_AXI_ARESETN  => s_axi4_aresetn,
      S_AXI_AWID     => s_axi4_awid,
      S_AXI_AWADDR   => s_axi4_awaddr,
      S_AXI_AWLEN    => s_axi4_awlen,
      S_AXI_AWSIZE   => s_axi4_awsize,
      S_AXI_AWBURST  => s_axi4_awburst,
      S_AXI_AWLOCK   => s_axi4_awlock,
      S_AXI_AWCACHE  => s_axi4_awcache,
      S_AXI_AWPROT   => s_axi4_awprot,
      S_AXI_AWQOS    => s_axi4_awqos,
      S_AXI_AWREGION => s_axi4_awregion,
      S_AXI_AWUSER   => s_axi4_awuser,
      S_AXI_AWVALID  => s_axi4_awvalid,
      S_AXI_AWREADY  => s_axi4_awready,
      S_AXI_WDATA    => s_axi4_wdata,
      S_AXI_WSTRB    => s_axi4_wstrb,
      S_AXI_WLAST    => s_axi4_wlast,
      S_AXI_WUSER    => s_axi4_wuser,
      S_AXI_WVALID   => s_axi4_wvalid,
      S_AXI_WREADY   => s_axi4_wready,
      S_AXI_BID      => s_axi4_bid,
      S_AXI_BRESP    => s_axi4_bresp,
      S_AXI_BUSER    => s_axi4_buser,
      S_AXI_BVALID   => s_axi4_bvalid,
      S_AXI_BREADY   => s_axi4_bready,
      S_AXI_ARID     => s_axi4_arid,
      S_AXI_ARADDR   => s_axi4_araddr,
      S_AXI_ARLEN    => s_axi4_arlen,
      S_AXI_ARSIZE   => s_axi4_arsize,
      S_AXI_ARBURST  => s_axi4_arburst,
      S_AXI_ARLOCK   => s_axi4_arlock,
      S_AXI_ARCACHE  => s_axi4_arcache,
      S_AXI_ARPROT   => s_axi4_arprot,
      S_AXI_ARQOS    => s_axi4_arqos,
      S_AXI_ARREGION => s_axi4_arregion,
      S_AXI_ARUSER   => s_axi4_aruser,
      S_AXI_ARVALID  => s_axi4_arvalid,
      S_AXI_ARREADY  => s_axi4_arready,
      S_AXI_RID      => s_axi4_rid,
      S_AXI_RDATA    => s_axi4_rdata,
      S_AXI_RRESP    => s_axi4_rresp,
      S_AXI_RLAST    => s_axi4_rlast,
      S_AXI_RUSER    => s_axi4_ruser,
      S_AXI_RVALID   => s_axi4_rvalid,
      S_AXI_RREADY   => s_axi4_rready
      );

-- Instantiation of Axi Bus Interface M_AXI4_LITE
  WishboneAXI_v0_1_M_AXI4_LITE_inst : WishboneAXI_v0_1_M_AXI4_LITE
    generic map (
      C_M_START_DATA_VALUE       => C_M_AXI4_LITE_START_DATA_VALUE,
      C_M_TARGET_SLAVE_BASE_ADDR => C_M_AXI4_LITE_TARGET_SLAVE_BASE_ADDR,
      C_M_AXI_ADDR_WIDTH         => C_M_AXI4_LITE_ADDR_WIDTH,
      C_M_AXI_DATA_WIDTH         => C_M_AXI4_LITE_DATA_WIDTH,
      C_M_TRANSACTIONS_NUM       => C_M_AXI4_LITE_TRANSACTIONS_NUM
      )
    port map (
      INIT_AXI_TXN  => m_axi4_lite_init_axi_txn,
      error         => m_axi4_lite_error,
      TXN_DONE      => m_axi4_lite_txn_done,
      M_AXI_ACLK    => m_axi4_lite_aclk,
      M_AXI_ARESETN => m_axi4_lite_aresetn,
      M_AXI_AWADDR  => m_axi4_lite_awaddr,
      M_AXI_AWPROT  => m_axi4_lite_awprot,
      M_AXI_AWVALID => m_axi4_lite_awvalid,
      M_AXI_AWREADY => m_axi4_lite_awready,
      M_AXI_WDATA   => m_axi4_lite_wdata,
      M_AXI_WSTRB   => m_axi4_lite_wstrb,
      M_AXI_WVALID  => m_axi4_lite_wvalid,
      M_AXI_WREADY  => m_axi4_lite_wready,
      M_AXI_BRESP   => m_axi4_lite_bresp,
      M_AXI_BVALID  => m_axi4_lite_bvalid,
      M_AXI_BREADY  => m_axi4_lite_bready,
      M_AXI_ARADDR  => m_axi4_lite_araddr,
      M_AXI_ARPROT  => m_axi4_lite_arprot,
      M_AXI_ARVALID => m_axi4_lite_arvalid,
      M_AXI_ARREADY => m_axi4_lite_arready,
      M_AXI_RDATA   => m_axi4_lite_rdata,
      M_AXI_RRESP   => m_axi4_lite_rresp,
      M_AXI_RVALID  => m_axi4_lite_rvalid,
      M_AXI_RREADY  => m_axi4_lite_rready
      );

-- Instantiation of Axi Bus Interface M_AXI4
  WishboneAXI_v0_1_M_AXI4_inst : WishboneAXI_v0_1_M_AXI4
    generic map (
      C_M_TARGET_SLAVE_BASE_ADDR => C_M_AXI4_TARGET_SLAVE_BASE_ADDR,
      C_M_AXI_BURST_LEN          => C_M_AXI4_BURST_LEN,
      C_M_AXI_ID_WIDTH           => C_M_AXI4_ID_WIDTH,
      C_M_AXI_ADDR_WIDTH         => C_M_AXI4_ADDR_WIDTH,
      C_M_AXI_DATA_WIDTH         => C_M_AXI4_DATA_WIDTH,
      C_M_AXI_AWUSER_WIDTH       => C_M_AXI4_AWUSER_WIDTH,
      C_M_AXI_ARUSER_WIDTH       => C_M_AXI4_ARUSER_WIDTH,
      C_M_AXI_WUSER_WIDTH        => C_M_AXI4_WUSER_WIDTH,
      C_M_AXI_RUSER_WIDTH        => C_M_AXI4_RUSER_WIDTH,
      C_M_AXI_BUSER_WIDTH        => C_M_AXI4_BUSER_WIDTH
      )
    port map (
      INIT_AXI_TXN  => m_axi4_init_axi_txn,
      TXN_DONE      => m_axi4_txn_done,
      error         => m_axi4_error,
      M_AXI_ACLK    => m_axi4_aclk,
      M_AXI_ARESETN => m_axi4_aresetn,
      M_AXI_AWID    => m_axi4_awid,
      M_AXI_AWADDR  => m_axi4_awaddr,
      M_AXI_AWLEN   => m_axi4_awlen,
      M_AXI_AWSIZE  => m_axi4_awsize,
      M_AXI_AWBURST => m_axi4_awburst,
      M_AXI_AWLOCK  => m_axi4_awlock,
      M_AXI_AWCACHE => m_axi4_awcache,
      M_AXI_AWPROT  => m_axi4_awprot,
      M_AXI_AWQOS   => m_axi4_awqos,
      M_AXI_AWUSER  => m_axi4_awuser,
      M_AXI_AWVALID => m_axi4_awvalid,
      M_AXI_AWREADY => m_axi4_awready,
      M_AXI_WDATA   => m_axi4_wdata,
      M_AXI_WSTRB   => m_axi4_wstrb,
      M_AXI_WLAST   => m_axi4_wlast,
      M_AXI_WUSER   => m_axi4_wuser,
      M_AXI_WVALID  => m_axi4_wvalid,
      M_AXI_WREADY  => m_axi4_wready,
      M_AXI_BID     => m_axi4_bid,
      M_AXI_BRESP   => m_axi4_bresp,
      M_AXI_BUSER   => m_axi4_buser,
      M_AXI_BVALID  => m_axi4_bvalid,
      M_AXI_BREADY  => m_axi4_bready,
      M_AXI_ARID    => m_axi4_arid,
      M_AXI_ARADDR  => m_axi4_araddr,
      M_AXI_ARLEN   => m_axi4_arlen,
      M_AXI_ARSIZE  => m_axi4_arsize,
      M_AXI_ARBURST => m_axi4_arburst,
      M_AXI_ARLOCK  => m_axi4_arlock,
      M_AXI_ARCACHE => m_axi4_arcache,
      M_AXI_ARPROT  => m_axi4_arprot,
      M_AXI_ARQOS   => m_axi4_arqos,
      M_AXI_ARUSER  => m_axi4_aruser,
      M_AXI_ARVALID => m_axi4_arvalid,
      M_AXI_ARREADY => m_axi4_arready,
      M_AXI_RID     => m_axi4_rid,
      M_AXI_RDATA   => m_axi4_rdata,
      M_AXI_RRESP   => m_axi4_rresp,
      M_AXI_RLAST   => m_axi4_rlast,
      M_AXI_RUSER   => m_axi4_ruser,
      M_AXI_RVALID  => m_axi4_rvalid,
      M_AXI_RREADY  => m_axi4_rready
      );

  -- Add user logic here

  -- User logic ends

end arch_imp;
