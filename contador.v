module contador (
  input clock,
  input BotaoPara,
  input BotaoReset, 
  input BotaoPause,
  output reg [0:6] display_ds,
  output reg [0:6] display_unid,
  output reg [0:6] display_dez,
  output reg [0:6] display_cent,
  output reg flagzerou
);


reg [31:0] conta = 0; // conta de pulsos
reg [3:0] display_c = 4'd0, display_d = 4'd0, display_u = 4'd0, display_dec = 4'd0;
reg [3:0] decimo = 4'd0;
reg [3:0] SegundoUni = 4'd0;
reg [3:0] SegundoDez = 4'd0;
reg [3:0] SegundoCen = 4'd0;
reg [1:0] flagpause;
reg [3:0] unidade_pausado, dezena_pausado, centena_pausado, ds_pausado;
integer parametro = 5000000; //parametro pro decimo de segundo

always @(negedge clock) begin

  if (BotaoReset == 0) begin
      decimo <= 4'd0;
      SegundoUni <= 4'd0;
      SegundoDez <= 4'd0;
      SegundoCen <= 4'd0;
  end

  if (BotaoPara == 1) begin
      if (conta < parametro) begin
          conta <= conta + 1; // incrementa o conta de pulsos
      end else begin
          conta <= 32'd0; // reseta o conta de pulsos
          if (decimo < 4'd9) begin
              decimo <= decimo + 1; // incrementa o conta de décimos
          end else begin
              decimo <= 4'd0; // reseta o conta de décimos ao atingir 9
              SegundoUni <= SegundoUni + 1;
              if (SegundoUni == 4'd9) begin
                  SegundoUni <= 4'd0;
                  SegundoDez <= SegundoDez + 1;
                  if (SegundoDez == 4'd9) begin
                      SegundoDez <= 4'd0;
                      SegundoCen <= SegundoCen + 1;
                  end
              end
          end
      end
  end

  if(decimo == 4'd9 && SegundoUni == 4'd9 && SegundoDez == 4'd9 && SegundoCen == 4'd9)begin
    flagzerou <= 1;
    end else begin
    flagzerou <= 0;
    end



  if(BotaoPause == 0) begin //se o botao pause for 0, ele foi pressionado 
      if (flagpause == 0) begin
      unidade_pausado <= SegundoUni;
      dezena_pausado <= SegundoDez;
      centena_pausado <= SegundoCen;
      ds_pausado <= decimo;
      flagpause <= 1;
    end
  end else begin
    flagpause <= 0; //se o botao pause for 1 (nao pressionado), a flagpause vai resetar pra 0
    end

 if (flagpause == 1) begin
    display_unid <= display(unidade_pausado);
    display_dez <= display(dezena_pausado);
    display_cent <= display(centena_pausado);
    display_ds <= display(ds_pausado);
  end else begin
    display_unid <= display(SegundoUni);
    display_dez <= display(SegundoDez);
    display_cent <= display(SegundoCen);
    display_ds <= display(decimo);
  end
end




function [6:0] display;
  input [3:0] numero;
  begin
    case (numero)
      4'd0: display = 7'b0000001;  
      4'd1: display = 7'b1001111;  
      4'd2: display = 7'b0010010;  
      4'd3: display = 7'b0000110;  
      4'd4: display = 7'b1001100;  
      4'd5: display = 7'b0100100;  
      4'd6: display = 7'b0100000;  
      4'd7: display = 7'b0001111;  
      4'd8: display = 7'b0000000;  
      4'd9: display = 7'b0000100;  
      default: display = 7'b1111111;  
    endcase
  end
endfunction
endmodule