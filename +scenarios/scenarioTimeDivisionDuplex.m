function simuParams = scenarioTimeDivisionDuplex()
    % Time Division Duplex (TDD) ISAC Scenario 
    
    % Scenario Generation.
    
    % Author: D.S.Xue, Key Laboratory of Universal Wireless Communications,
    % Ministry of Education, BUPT.
    
    %%
    rng('default')
    
    %% Simulation Time
    numFrames = 1; % Number of radio frames (10 ms)
    
    %% Base Station
    % Initialize bs
    bs = networkElements.baseStation.gNB;
    bs.ID               = 1;
    bs.position         = [0 0 10];              % in meters
    bs.txPower          = 46;                    % in dBm
    bs.carrierFrequency = 28.50e9;               % in Hz
    bs.bandwidth        = 100;                   % in MHz
    bs.scs              = 60;                    % in kHz
    bs.tddPattern       = ["D" "D" "D" "S" "U"]; % TDD pattern
    bs.specialSlot      = [10 2 2];              % TDD special/flexible slot
    bs.antSize          = [8 1 2];               % antenna panel
    bs.estAlgorithm     = 'FFT';                 % estimation algorithm
    bs.Pfa              = 1e-9;                  % false alarm rate
    bs.cfarEstZone      = [50 500; -20 20];      % [a b; c d], a to b m, c to d m/s

    % Attached UEs
    ue = networkElements.ue.basicUE();
    ue.ID       = 1;
    ue.position = [100 100 1.5];  % in meters
    ueParams    = ue;
    
    % Attached targets
    tgt = networkElements.target.basicTarget();
    tgt.ID       = 1;
    tgt.position = [100 100 1.5];  % in meters
    tgt.rcs      = 1;              % in meters^2
    tgt.velocity = 5;              % in meters per second
    tgtParams    = tgt;
    
    % Update bs and UE/target pairs
    bs.attachedUEs  = ueParams;
    bs.attachedTgts = tgtParams;
    
    % Get topology params
    topoParams = networkTopology.getTopoParams(bs);
    
    % Generate communication channel models
    comChannel = communication.channelModels.cdlModel;
    comChannel.carrierFrequency = bs.carrierFrequency;
    comChannel.delayProfile     = 'CDL-D';
    comChannel.attachedUEs      = ueParams;
    comChannel.antConfig        = bs.antConfig;
    comChannel.topoParams       = topoParams;

    %% Simulation Params
    simuParams.numFrames  = numFrames;
    simuParams.bsParams   = bs;
    simuParams.topoParams = topoParams;
    simuParams.chlParams  = comChannel.models;

end