class SpritePaths {
  static const brick = 'blocks/brick.png';
  static const leftBasePiece = 'blocks/left_base_piece.png';
  static const middleBasePiece = 'blocks/middle_base_piece.png';
  static const rightBasePiece = 'blocks/right_base_piece.png';
  static const subsurfBasePiece = 'blocks/subsurf_base_piece.png';
  static const crate = 'blocks/crate.png';
  static const heavyCrate = 'blocks/heavy_crate.png';
  static const iceblock = 'blocks/iceblock.png';
  static const metalCrate = 'blocks/metal_box.png';
  static const singleTree = 'blocks/tree.png';
  static const trees = 'blocks/trees.png';
  static const stone = 'blocks/stone.png';
  static const leftPlatPiece = 'blocks/left_platform_piece.png';
  static const midPlatPiece = 'blocks/mid_platform_piece.png';
  static const rightPlatPiece = 'blocks/right_platform_piece.png';
  static const grate = 'blocks/grate.png';

  static const all = [
    leftBasePiece,
    brick,
    middleBasePiece,
    rightBasePiece,
    subsurfBasePiece,
    leftPlatPiece,
    midPlatPiece,
    rightPlatPiece,
    crate,
    heavyCrate,
    metalCrate,
    iceblock,
    singleTree,
    trees,
    stone,
    grate,
  ];

  static const permeable = [grate];

  static bool isPermeable(String path) => permeable.contains(path);
}
