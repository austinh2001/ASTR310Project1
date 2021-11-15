calibHafull = rfits('calibrated_Ha_M27.fit',0);
calibHa = calibHafull.data;
skyNoiseRegion = calibHa(1100:1300,700:900);
skyNoiseMu = median(skyNoiseRegion,'all')
skyNoiseSigma = std(skyNoiseRegion,1,'all')
threshADU = skyNoiseMu+4*skyNoiseSigma