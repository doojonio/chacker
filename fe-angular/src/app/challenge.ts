import { Task, TaskDto } from './task';
import { UploadedImage } from './uploaded-image';

export const ChallengeDtoFields: string[] = [
  'id',
  'title',
  'description',
  'tasks',
  'state',
  'picture',
  'create_time',
  'change_time',
];
export class ChallengeDto {
  id: number;
  title: number;
  description: number;
  tasks: TaskDto[];
  state: ChallengeState;
  picture: UploadedImage;

  // ---
  // snakecase fields from webservices (added for compatibility)
  // ---
  create_time: string;
  change_time: string;
  // ---
}
export class Challenge extends ChallengeDto {
  tasks: Task[];
  pictureUrl: string;
  createTime: string;
  changeTime: string;
}

export enum ChallengeState {
  inProgress = 'in progress',
  completed = 'completed',
  new = 'new',
  failed = 'failed',
}
