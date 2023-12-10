const unit = 8.0;
const tick = 1 / 60;
const longTick = 1 / 8;
const waterSubdivision = 1 / 8;
const temperatureSubdivision = 1 / 16;
const heatTransferRate = 0.5;

abstract class Flags {
  static const feet = 'feet';
  static const permeable = 'permeable';
}
