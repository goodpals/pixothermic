const unit = 8.0;
const tick = 1 / 60;
const longTick = 1 / 8;
const waterSubdivision = 1 / 16;
const temperatureSubdivision = 1 / 16;
const heatTransferRate = 0.5;
const lightHeatThresold = 0.4;
const lightReflectionCutoff = 0.05;

abstract class Flags {
  static const feet = 'feet';
  static const permeable = 'permeable';
  static const portal = 'portal';
}
