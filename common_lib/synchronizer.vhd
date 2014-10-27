---------------------------------
-- Block name and description --
--------------------------------

---------------
-- Libraries --
---------------
library	ieee;
    use ieee.std_logic_1164.all;  
    use ieee.std_logic_arith.all;			   

library common_lib;
    use common_lib.common_pkg.all;

------------------------
-- Entity declaration --
------------------------
entity synchronizer is
    generic (
        SYNC_STAGES  : positive := 2;
        DATA_WIDTH   : integer  := 1
        );
    port (
        -- Usual ports
        clk     : in  std_logic;
        clken   : in  std_logic;

        -- Block specifics
        din     : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        dout    : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end synchronizer;

architecture synchronizer of synchronizer is

    -----------
    -- Types --
    -----------
    type din_t is array (natural range <>) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    -------------
    -- Signals --
    -------------
    signal din_sr   : din_t(SYNC_STAGES - 1 downto 0);

begin

    -------------------
    -- Port mappings --
    -------------------

    ------------------------------
    -- Asynchronous assignments --
    ------------------------------

    ---------------
    -- Processes --
    ---------------
    process(clk)
        variable is_stable : boolean;
    begin
        if clk'event and clk = '1' then
            if clken = '1' then
                din_sr  <= din_sr(SYNC_STAGES - 2 downto 0) & din;
                
                is_stable := true;
                for i in 0 to SYNC_STAGES - 2 loop
                    if din_sr(i) /= din_sr(SYNC_STAGES - 1) then
                        is_stable := false;
                        exit;
                    end if;
                end loop;

                if is_stable then
                    dout <= din_sr(SYNC_STAGES - 1);
                end if;

            end if;
        end if;
    end process;


end synchronizer;

