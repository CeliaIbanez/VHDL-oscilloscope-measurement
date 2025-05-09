library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    generic (
        C_SAMPLE_FREQ : integer := 125000000;
        C_CHANNEL_ADDR : std_logic_vector(6 downto 0) := "0010001"
    );
    Port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;

        -- User ports
        start_i : in std_logic;
        leds_o : out std_logic_vector(11 downto 0);
        -- User ports end

        -- DRP interface
        den_o : out STD_LOGIC;
        daddr_o : out STD_LOGIC_VECTOR (6 downto 0);
        di_o : out STD_LOGIC_VECTOR (15 downto 0);
        do_i : in STD_LOGIC_VECTOR (15 downto 0);
        drdy_i : in STD_LOGIC;
        dwe_o : out STD_LOGIC
    );
end controller;

architecture Behavioral of controller is

    type state_type is (S_IDLE, S_ACQ, S_WAIT);
    signal current_state, next_state : state_type;
---------variables de contador    
    constant CONT_max  : integer:= C_SAMPLE_FREQ;
    signal contador : integer range 0 to CONT_max-1;
    signal temp   : std_logic;
    signal enableCONT       : std_logic:='0';

begin

    -- Registro de estado
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            current_state <= S_IDLE;
        elsif rising_edge(clk_i) then
            current_state <= next_state;
        end if;
    end process;

    -- Lógica de transición de estados
    process(current_state, start_i, temp)
    begin
        case current_state is
            when S_IDLE =>
                if start_i = '1' then
                    next_state <= S_ACQ;
                else
                    next_state <= S_IDLE;
                end if;

            when S_ACQ =>
                next_state <= S_WAIT;

            when S_WAIT =>
                
                if temp = '0' then
                    next_state <= S_IDLE;
                    enableCONT <= '0';
                else
                    enableCONT <= '1';
                    next_state <= S_WAIT;
                end if;

            when others =>
                next_state <= S_IDLE;
        end case;
    end process;

    -- Salidas (puedes agregar lógica aquí si es necesario)
-----------------------------------------------------------------
-- DIVISOR DE FRECUENCIA 1Hz
-----------------------------------------------------------------
process(clk_i,rst_i)
begin
     if (rst_i ='1') then
         contador <= 0;
     elsif (clk_i'event and clk_i ='1') then
            if (enableCONT ='1') then
                if (contador < CONT_max) then
                     contador <= contador +1;
                 else  contador <=0;
                 end if;
             end if;
      end if;           
end process;
 temp <= '0' when (contador = CONT_max-1) else '1'; 


end Behavioral;