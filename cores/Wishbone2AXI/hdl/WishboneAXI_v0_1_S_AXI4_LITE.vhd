-------------------------------------------------------------------------------
-- Title      :
-- Project    : Wishbone2AXI
-------------------------------------------------------------------------------
-- File       : WishboneAXI_vX_Y_S_AXI4_LITE.vhd
-- Authors    : Adrian Byszuk <adrian.byszuk@gmail.com>
--            : Piotr Miedzik (Qermit)
-- Company    :
-- Created    : 2016-06-06
-- Last update: 2016-06-23
-- License    : This is a PUBLIC DOMAIN code, published under
--              Creative Commons CC0 license
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: AXI4Lite -> WB bridge
-------------------------------------------------------------------------------
-- Copyright (c) 2016
-------------------------------------------------------------------------------
-- Revisions  : see git reflog
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Implementation details
-------------------------------------------------------------------------------
-- In the AXI bus the read and write accesses may be handled independently
-- but in Wishbone they can't, therefore we must provide an arbitration scheme.
-- We assume "Write before read"
-- To ease bridging, both AXI and WB use byte addressing. WB uses byte select.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.genram_pkg.all;
use work.wishbone_pkg.all;
use work.axi_helpers_pkg.all;
use work.wb_helpers_pkg.all;


entity wishboneaxi_v0_2_s_axi4_lite is
  generic (
    -- Users to add parameters here
    C_WB_ADR_WIDTH : integer;
    C_WB_DAT_WIDTH : integer;
    C_WB_MODE      : t_wishbone_interface_mode ;
    -- User parameters ends
    -- Do not modify the parameters beyond this line

    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH : integer := 32;
    -- Width of S_AXI address bus
    C_S_AXI_ADDR_WIDTH : integer := 32
    );
  port (
  
    aclk : in std_logic;
    aresetn : in std_logic;
    -- Users to add ports here
	m_wb_m2s : out t_wishbone_master_out;
    m_wb_s2m : in  t_wishbone_slave_out;
    -- User ports ends
    -- Do not modify the ports beyond this line
    s_axi_m2s : in t_axi4_m2s;
    s_axi_s2m : out t_axi4_s2m
    
    );
end wishboneaxi_v0_2_s_axi4_lite;

architecture arch_imp of wishboneaxi_v0_2_s_axi4_lite is

component  inferred_sync_fifo is

  generic (
    g_data_width : natural;
    g_size       : natural;
    g_show_ahead : boolean := false;

    -- Read-side flag selection
    g_with_empty        : boolean := true;   -- with empty flag
    g_with_full         : boolean := true;   -- with full flag
    g_with_almost_empty : boolean := false;
    g_with_almost_full  : boolean := false;
    g_with_count        : boolean := false;  -- with words counter

    g_almost_empty_threshold : integer := 0;  -- threshold for almost empty flag
    g_almost_full_threshold  : integer := 0;  -- threshold for almost full flag

    g_register_flag_outputs : boolean := true
    );

  port (
    rst_n_i : in std_logic := '1';

    clk_i : in std_logic;
    d_i   : in std_logic_vector(g_data_width-1 downto 0);
    we_i  : in std_logic;

    q_o  : out std_logic_vector(g_data_width-1 downto 0);
    rd_i : in  std_logic;

    empty_o        : out std_logic;
    full_o         : out std_logic;
    almost_empty_o : out std_logic;
    almost_full_o  : out std_logic;
    count_o        : out std_logic_vector(f_log2_size(g_size)-1 downto 0)
    );

end component;

  type t_trans_state is (IDLE, AW_LATCH, W_LATCH, W_SEND, W_RESP, R_SEND, R_RESP);
  signal trans_state : t_trans_state := IDLE;

  -- AXI4LITE signals
  signal axi_awready      : std_logic;
  signal axi_wready       : std_logic;
  signal axi_wdata        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal axi_bresp        : std_logic_vector(1 downto 0);
  signal axi_bvalid       : std_logic;
  signal axi_arready      : std_logic;
  signal axi_rdata        : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal axi_rresp        : std_logic_vector(1 downto 0);
  signal axi_rvalid       : std_logic;
  signal axi_araddr       : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_araddr_read  : std_logic := '0';
  signal axi_araddr_empty : std_logic;
  signal axi_araddr_full  : std_logic;

  signal wb_adr   : std_logic_vector(C_WB_ADR_WIDTH-1 downto 0);
  signal wb_dat_w : std_logic_vector(C_WB_DAT_WIDTH-1 downto 0);
  signal wb_cyc   : std_logic;
  signal wb_stb   : std_logic;
  signal wb_lock  : std_logic;
  signal wb_sel   : std_logic_vector(C_WB_DAT_WIDTH/8-1 downto 0);
  signal wb_we    : std_logic;

begin

  w_translate : process (aclk) is
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        axi_awready <= '0';
        axi_wready  <= '0';
        axi_bresp   <= "00";
        axi_bvalid  <= '0';
        axi_rdata   <= (others => '0');
        axi_rresp   <= "00";
        axi_rvalid  <= '0';
        wb_adr      <= (others => '0');
        wb_dat_w    <= (others => '0');
        wb_cyc      <= '0';
        wb_stb      <= '0';
        wb_lock     <= '0';
        wb_sel      <= (others => '0');
        wb_we       <= '0';
        trans_state <= IDLE;
      else
        case trans_state is
          when IDLE =>
            --keep [awready, wready] high to avoid wasting clock cycles
            axi_awready <= '1';
            axi_wready  <= '1';
            axi_bvalid  <= '0';
            axi_rvalid  <= '0';
            wb_cyc      <= '0';
            -- stb not necessary by spec., but lack of this probably will wreak havoc amongst badly implemented slaves
            wb_stb      <= '0';

            if (axi_awready and s_axi_m2s.AWVALID) = '1' and (axi_wready and s_axi_m2s.WVALID) = '0' then
              axi_awready <= '0';
              wb_adr      <= s_axi_m2s.AWADDR;
              trans_state <= AW_LATCH;
            elsif (axi_awready and s_axi_m2s.AWVALID) = '0' and (axi_wready and s_axi_m2s.WVALID) = '1' then
              axi_wready  <= '0';
              wb_dat_w    <= s_axi_m2s.WDATA(31 downto 0);
              wb_sel      <= s_axi_m2s.WSTRB(3 downto 0);
              trans_state <= W_LATCH;
            elsif (axi_awready and s_axi_m2s.AWVALID) = '1' and (axi_wready and s_axi_m2s.WVALID) = '1' then
              axi_awready <= '0';
              axi_wready  <= '0';
              wb_cyc      <= '1'; --push cycle to WB as soon as possible
              wb_stb      <= '1';
              wb_we       <= '1';
              wb_adr      <= s_axi_m2s.AWADDR;
              wb_dat_w    <= s_axi_m2s.WDATA(31 downto 0);
              wb_sel      <= s_axi_m2s.WSTRB(3 downto 0);
              trans_state <= W_SEND;
            elsif axi_araddr_empty = '0' then
              wb_adr      <= axi_araddr;
              wb_cyc      <= '1';
              wb_stb      <= '1';
              wb_we       <= '0';
              trans_state <= R_SEND;
            end if;
          --AXI specification explicitly says that no relationship between input channels is defined (A3.3)
          --It means that write data can appear before write address and vice versa. It is slave's responsibility
          --to align channels if that's necessary for proper slave operation.
          when AW_LATCH =>
            axi_awready <= '0';
            if (axi_wready and s_axi_m2s.WVALID) = '1' then
              axi_wready  <= '0';
              wb_cyc      <= '1';
              wb_stb      <= '1';
              wb_we       <= '1';
              wb_dat_w    <= s_axi_m2s.WDATA(31 downto 0);
              wb_sel      <= s_axi_m2s.WSTRB(3 downto 0);
              trans_state <= W_SEND;
            end if;

          when W_LATCH =>
            axi_wready <= '0';
            if (axi_awready and s_axi_m2s.AWVALID) = '1' then
              axi_awready <= '0';
              wb_cyc      <= '1';
              wb_stb      <= '1';
              wb_we       <= '1';
              wb_adr      <= s_axi_m2s.AWADDR;
              trans_state <= W_SEND;
            end if;

          --W_SEND state is quite complicated and delicate. We want to support back-to-back transactions when it's
          --possible. But to do that Classic WB slave must support asynchronous cycle termination and AXI-LITE master
          --has to push aligned transfers on AW and W channels AND have response channel ready.
          when W_SEND =>
            axi_awready <= '0';
            axi_wready  <= '0';
            axi_bresp   <= "00";
            axi_bvalid  <= '0';
            wb_cyc      <= '1';
            if C_WB_MODE = CLASSIC then 
              wb_stb      <= '1';
            else -- PIPELINED
              wb_stb <= m_wb_s2m.stall;
            end if;
            wb_we       <= '1';
            --if C_WB_MODE = "CLASSIC" then
              if (m_wb_s2m.ack or m_wb_s2m.err or m_wb_s2m.rty) = '1' then
                axi_bresp(1) <= not(m_wb_s2m.ack);  --if it's not ACK, then it must be slave error
                axi_bvalid   <= '1';
                wb_stb       <= '0';  --only strobe, keep cycle high in hope of new data
                if s_axi_m2s.BREADY = '0' then
                  trans_state <= W_RESP;
                -- according to AXI spec. *VALID signal, once asserted, *must* remain asserted until *READY is asserted
                -- so we can latch data and set *ready in next cycle
                elsif (s_axi_m2s.AWVALID and s_axi_m2s.WVALID) = '1' then
                  axi_awready <= '1';
                  axi_wready  <= '1';  --toogle ready signals to latch axi data
                  wb_stb      <= '1';
                  wb_adr      <= s_axi_m2s.AWADDR;
                  wb_dat_w    <= s_axi_m2s.WDATA(31 downto 0);
                  wb_sel      <= s_axi_m2s.WSTRB(3 downto 0);
                else
                  axi_awready <= '1';
                  axi_wready  <= '1';  --prepare early for next cycle
                  wb_cyc      <= '0';
                  trans_state <= IDLE;
                end if;
              end if;
            --end if;

          when W_RESP =>
            axi_awready <= '0';
            axi_wready  <= '0';
            axi_bresp   <= axi_bresp;
            axi_bvalid  <= '1';
            wb_stb      <= '0';
            --if C_WB_MODE = CLASSIC then
              if s_axi_m2s.BREADY = '1' then
                axi_bvalid <= '0';
                if (s_axi_m2s.AWVALID and s_axi_m2s.WVALID) = '1' then
                  axi_awready <= '1';
                  axi_wready  <= '1';  --toogle ready signals to latch axi data
                  wb_cyc      <= '1';
                  wb_stb      <= '1';
                  wb_we       <= '1';
                  wb_adr      <= s_axi_m2s.AWADDR;
                  wb_dat_w    <= s_axi_m2s.WDATA(31 downto 0);
                  wb_sel      <= s_axi_m2s.WSTRB(3 downto 0);
                  trans_state <= W_SEND;
                else
                  axi_awready <= '1';
                  axi_wready  <= '1';   --prepare early for next cycle
                  wb_cyc      <= '0';
                  trans_state <= IDLE;
                end if;
              end if;
            --end if;

          when R_SEND =>
            axi_rresp  <= "00";
            axi_rvalid <= '0';
            wb_cyc     <= '1';
            if C_WB_MODE = CLASSIC then 
              wb_stb      <= '1';
            else -- PIPELINED
              wb_stb <= m_wb_s2m.stall;
            end if;
            wb_we      <= '0';
            
              if (m_wb_s2m.ack or m_wb_s2m.err or m_wb_s2m.rty) = '1' then
                axi_rdata    <= m_wb_s2m.dat;
                axi_rresp(1) <= not(m_wb_s2m.ack);
                axi_rvalid   <= '1';
                wb_stb       <= '0';
                if s_axi_m2s.RREADY = '0' then
                  trans_state <= R_RESP;
                elsif axi_araddr_empty = '0' then
                  wb_adr <= axi_araddr;
                  wb_stb <= '1';
                else
                  wb_cyc      <= '0';
                  trans_state <= R_RESP;
                end if;
              end if;

          when R_RESP =>
            axi_rresp  <= axi_rresp;
            axi_rvalid <= '1';
            wb_stb     <= '0';
            --if C_WB_MODE = "CLASSIC" then
              if s_axi_m2s.RREADY = '1' then
                axi_rvalid <= '0';
                if axi_araddr_empty = '0' then
                  wb_adr      <= axi_araddr;
                  wb_stb      <= '1';
                  trans_state <= R_SEND;
                else
                  wb_cyc      <= '0';
                  trans_state <= IDLE;
                end if;
              end if;
          --  end if;
--coverage off
          when others =>
            axi_awready <= '0';
            axi_wready  <= '0';
            axi_bvalid  <= '0';
            axi_rvalid  <= '0';
            wb_cyc      <= '0';
            wb_stb      <= '0';
            trans_state <= IDLE;
--coverage on
        end case;
      end if;
    end if;
  end process;

  --used to drive some specific signals which need to change state in the same clock cycle
  translate_comb : process(trans_state, s_axi_m2s.RREADY, axi_araddr_empty, m_wb_s2m.ack, m_wb_s2m.err, m_wb_s2m.rty)
  begin
    case trans_state is
      when IDLE =>
        axi_araddr_read <= '0';
        if axi_araddr_empty = '0' then
          axi_araddr_read <= '1';
        end if;

      when R_SEND =>
        axi_araddr_read <= '0';
        if C_WB_MODE = CLASSIC then
          if (m_wb_s2m.ack or m_wb_s2m.err or m_wb_s2m.rty) = '1' then
            if axi_araddr_empty = '0' and s_axi_m2s.RREADY = '1' then  --start next read asap to support b2b reads
              axi_araddr_read <= '1';
            end if;
          end if;
        end if;
      when R_RESP =>
        axi_araddr_read <= '0';
        if C_WB_MODE = CLASSIC then
          if s_axi_m2s.RREADY = '1' then
            if axi_araddr_empty = '0' then
              axi_araddr_read <= '1';
            end if;
          end if;
        end if;

      when others =>
        axi_araddr_read <= '0';

    end case;
  end process;

  --To avoid wasted cycles put read requests on a queue. Combined with Wishbone's asynchronous cycle
  --termination or pipelined mode will prove very useful for achieving high bus throughput.
  ar_queue : inferred_sync_fifo
    generic map (
      g_data_width        => C_S_AXI_ADDR_WIDTH,
      g_size              => 4,
      g_show_ahead        => true,
      g_with_empty        => true,
      g_with_full         => true,
      g_with_almost_empty => false,
      g_with_almost_full  => false,
      g_with_count        => false
      )
    port map (
      rst_n_i => ARESETN,
      clk_i   => ACLK,
      d_i     => s_axi_m2s.ARADDR,
      we_i    => s_axi_m2s.ARVALID,
      q_o     => axi_araddr,
      rd_i    => axi_araddr_read,
      empty_o => axi_araddr_empty,
      full_o  => axi_araddr_full
      );

  axi_arready <= '0' when aresetn = '0' else not(axi_araddr_full); --to comply with spec under reset
  -- I/O Connections assignments
  s_axi_s2m.AWREADY <= axi_awready;
  s_axi_s2m.WREADY  <= axi_wready;
  s_axi_s2m.BRESP   <= axi_bresp;
  s_axi_s2m.BVALID  <= axi_bvalid;
  s_axi_s2m.ARREADY <= axi_arready;
  s_axi_s2m.RDATA(31 downto 0)   <= axi_rdata;
  s_axi_s2m.RDATA(127 downto 32)   <= (others => '0');
  s_axi_s2m.RRESP   <= axi_rresp;
  s_axi_s2m.RVALID  <= axi_rvalid;

  m_wb_m2s.adr   <= wb_adr;
  m_wb_m2s.dat   <= wb_dat_w;
  m_wb_m2s.cyc   <= wb_cyc;
  m_wb_m2s.stb   <= wb_stb;
  --m_wb_m2s.lock  <= wb_lock;
  m_wb_m2s.sel   <= wb_sel;
  m_wb_m2s.we    <= wb_we;


  assert (C_S_AXI_DATA_WIDTH = C_WB_DAT_WIDTH)
    report "AXI-Lite->Wishbone bridge doesn't support data width conversion. " & lf &
    "C_S_AXI_DATA_WIDTH=" & integer'image(C_S_AXI_DATA_WIDTH) &
    " C_WB_DAT_WIDTH=" & integer'image(C_WB_DAT_WIDTH)
    severity failure;

  assert (C_WB_MODE = CLASSIC or C_WB_MODE = PIPELINED)
    report "Incorrect C_WB_MODE: " & f_wb_type_to_str(C_WB_MODE)
    severity failure;

end arch_imp;
