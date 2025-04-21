
module cronometro (
  input clock, 
  input reset, 
  input conta, 
  input para, 
  input pausa, 
  output [0:6] display_dec_sec,
  output [0:6] display_unidade,
  output [0:6] display_dezena,
  output [0:6] display_centena
);

reg [1:0] state = 0;
parameter contando = 3, zerado = 0, pausado = 2, parado = 1;
reg parar, zerar, pausar, contar; // Flags para controlar o que acontece em cada estado, ja que os botoes voltam para nivel logico 1 depois que solta 


// Instanciação do contador
contador cont (
    .clock(clock),
    .BotaoPara(parar),
    .BotaoReset(zerar),
    .BotaoPause(pausar),
    .display_cent(display_centena),
    .display_unid(display_unidade),
    .display_dez(display_dezena),
    .display_ds(display_dec_sec),
     .flagzerou(flagz)

);

// Parte combinacional - Parte responsável pelo que acontece em cada estado. 
always @(*) begin
  case (state)
      contando: begin //Contando - Display e Contador não param de atualizar.
        zerar = 1;
        pausar = 1;
        parar = 1;

          end
      zerado: begin //Zerado - Todas as unidades de tempo são redefinidas para 0 e 
        zerar = 0;
        parar = 0; 
        pausar = 1;

          end
      pausado: begin //Ideia é que pare de atualizar o display, mas continue a incrementar no contador. 
        pausar = 0; 
        parar = 1; 
        zerar = 1;

          end
      parado:  begin  //Ideia é que pare de atualizar o display e pare de atualizar o cronômetro. 
        pausar = 1;
        zerar = 1; 
        parar = 0;

          end
  endcase
end

// Parte sequencial - Parte responsável pela transição entre os estados. 
    always @(posedge clock) begin
      case (state)
          contando: begin
          if (reset == 0 || flagz == 1)
              state <= zerado;
          else if (para == 0)
              state <= parado;
          else if (pausa == 0)
              state <= pausado;
          end
          zerado: begin
          if (conta == 0)
              state <= contando;
          else if (para == 0)
              state <= parado;
          else if (pausa == 0)
              state <= pausado;
          end
          pausado: begin
          if (conta == 0)
              state <= contando;
          else if (reset == 0)
              state <= zerado;
          else if (para == 0)
              state <= parado;
          end
          parado: begin
          if (conta == 0)
              state <= contando;
          else if (reset == 0)
              state <= zerado;
          end
          default: begin
          state <= zerado;
          end
      endcase
end
endmodule