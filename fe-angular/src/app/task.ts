import { UploadedImage } from './uploaded-image';

export const TaskDtoFields: string[] = [
  "id",
  "title",
  "description",
  "state",
  "type",
  "picture",
  "create_time",
  "change_time",
];
export class TaskDto {
  id: number;
  title: string;
  description: string;
  state: TaskState;
  type: TaskType;
  picture: UploadedImage;

  // ---
  // snakecase fields from webservices (added for compatibility)
  // ---
  create_time: string;
  change_time: string;
  // ---
};
export class Task extends TaskDto {
  pictureUrl: string;
  createTime: string;
  changeTime: string;
}

export enum TaskType {
  once =  'once',
  days = 'days',
}

export enum TaskState {
  inProgress = 'in progress',
  completed = 'completed',
  new = 'new',
  failed = 'failed',
}
