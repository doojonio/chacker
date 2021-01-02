export class UploadedImage {
  id: number;
  path: string;
  name: string;
  uploadTime: string;

  storageUrl: string;

  // Webservice snakecase fields
  upload_time: string;
}

export enum ImageShapeFormat {
  wide = 16 / 9,
  photo = 4 / 3,
}
