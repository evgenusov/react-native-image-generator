export interface IPictureLayer {
  uri: string;
  width: number;
  height: number;
  x: number;
  y: number;
}


export interface ITextLayer {
  text: string;
  fontSize?: number;
  fontName?: string;
  color: [number, number, number, number];
  width: number;
  height: number;
  x: number;
  y: number;
}

export type ILayer = IPictureLayer | ITextLayer;

export interface IConfig {
  filename: string;
  width: number;
  height: number;
}
