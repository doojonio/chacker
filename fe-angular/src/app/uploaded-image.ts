export class UploadedImage {
  id: number;
  path: string;
  filename: string;
  uploadTime: string;

  // Webservice snakecase fields
  upload_time: string;
}
