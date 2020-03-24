function convconm(n, x, h, g, nameGif, minT, maxT, tMin, tMax, yMin, yMax, convYmin, convYmax)
  gFunc = func2str(g);
  figScreen = figure (n); % Se crea una figura para hacer las gráficas
  dtau = 0.005; % Base de los rectangulos para realizar la integral 
  tau = tMin:dtau:tMax; % Intervalo de visualización del resultado
  ti = 0; % Indice para el vector de resultados
  tvec = minT:.1:maxT; % traslaciones de t, cuantas integrales se calulan
  i=1; % Indice para cantidad de frames a utilizar
  y = NaN*zeros(1, length (tvec)); % Resultados de acuerdo a cuantos t
  
  for t = tvec % Cantidad de traslaciones
      ti = ti+1; % Indice para guardar el resultado (indice del tiempo)
      xh = x(t-tau).*h(tau); % resultado de la multiplicación 
      lxh = length(xh); % longitud del resultado
      y(ti) = sum(xh.*dtau); % Base por altura, aproximación de la integral
      
      subplot (2,1,1), % gráfica de 2 x 1 (primera)
      plot(tau, h(tau), 'r-', tau, x(t-tau), 'g--', t, 0, 'ob'); %graficas 
      axis ([tau(1) tau(end) yMin yMax]); % límites de los ejes
      patch([tau(1:end-1); tau(1:end-1); tau(2:end); tau(2:end)],...
      [zeros(1,lxh-1);xh(1:end-1);xh(2:end);zeros(1,lxh-1)],...
      [.8 .8 .8], 'edgecolor', 'none');
      xlabel('\tau'); % Texto del eje X
      ylabel ('y(\tau)');
      legend('h(\tau)', 'x(t-\tau)','t','h(\tau)x(t-\tau)')% Caja de Texto
      
      subplot (2, 1, 2)  % gráfica de 2 x 1 (segunda)
      plot (tau, g(tau), 'r-', tvec, y, 'g--', tvec (ti), y(ti), 'ok');
      xlabel ('t'); 
      ylabel ('y(t) = \int h(\tau)x(t-\tau) d\tau');
      axis ([tau(1) tau(end) convYmin convYmax]); % límites del eje
      %legend(['g(t) = ',gFunc], 'y(t) MATLAB')
      grid; % malla
      
      drawnow; % efecto de movimiento continuo
      % Capturamos la figura como frame para el gif
      frame = getframe(figScreen); % Obtenemos el tamano de la figura 
      im{i} = frame2im(frame);
      i=i+1; 
    end
    
    % Comenzamos creacion de gif
    gifFilename = nameGif; % Nombramos el gif 
    nImages = length(tvec);
    for idx = 1:nImages
        [A,map] = rgb2ind(im{idx},256);
        if idx == 1
            imwrite(A,map,gifFilename,'gif','LoopCount',Inf,'DelayTime',1);
        else
            imwrite(A,map,gifFilename,'gif','WriteMode','append','DelayTime',1);
        end
    end
  end