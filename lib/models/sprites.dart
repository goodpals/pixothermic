class SpritePaths {
  static const brick = 'blocks/brick.png';
  static const brick1 = 'blocks/brick1.png';
  static const brick2 = 'blocks/brick2.png';
  static const brick3 = 'blocks/brick3.png';
  static const brick4 = 'blocks/brick4.png';
  static const dirt1 = 'blocks/dirt1.png';
  static const dirt2 = 'blocks/dirt2.png';
  static const leftBasePiece = 'blocks/left_base_piece.png';
  static const middleBasePiece = 'blocks/middle_base_piece.png';
  static const rightBasePiece = 'blocks/right_base_piece.png';
  static const subsurfBasePiece = 'blocks/subsurf_base_piece.png';
  static const crate = 'blocks/crate.png';
  static const heavyCrate = 'blocks/heavy_crate.png';
  static const iceBlock = 'blocks/iceblock.png';
  static const mirror = 'blocks/mirror.png';
  static const metalCrate = 'blocks/metal_box.png';
  static const singleTree = 'blocks/tree.png';
  static const trees = 'blocks/trees.png';
  static const stone = 'blocks/stone.png';
  static const leftPlatPiece = 'blocks/left_platform_piece.png';
  static const midPlatPiece = 'blocks/mid_platform_piece.png';
  static const rightPlatPiece = 'blocks/right_platform_piece.png';
  static const grate = 'blocks/grate.png';

  static const spawn = 'blocks/spawn.png';
  static const goal = 'blocks/exit.png';

  static const foregroundTiles = [
    brick,
    brick1,
    brick2,
    brick3,
    brick4,
    dirt1,
    dirt2,
    leftBasePiece,
    middleBasePiece,
    rightBasePiece,
    subsurfBasePiece,
    leftPlatPiece,
    midPlatPiece,
    rightPlatPiece,
    stone,
    grate,
  ];

  static const all = [
    ...foregroundTiles,
    crate,
    heavyCrate,
    metalCrate,
    iceBlock,
    mirror,
    singleTree,
    trees,
    spawn,
    goal,
  ];

  static const permeable = [grate];

  static bool isPermeable(String path) => permeable.contains(path);
}
