import { UploadedImage } from './uploaded-image';

export class Task {
  id: number;
  title: string;
  description: string;
  state: TaskStates;
  picture: UploadedImage;
  pictureUrl: string;

  createTime: string;
  changeTime: string;

  // ---
  // snakecase fields from webservices (added for compatibility)
  // ---
  create_time: string;
  change_time: string;
  // ---
}

export enum TaskStates {
  inProgress = 'in progress',
  completed = 'completed',
  new = 'new',
  failed = 'failed',
}
