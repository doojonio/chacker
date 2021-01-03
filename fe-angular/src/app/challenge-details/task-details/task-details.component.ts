import { Task } from 'src/app/task';

import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-task-details',
  templateUrl: './task-details.component.html',
  styleUrls: ['./task-details.component.scss'],
})
export class TaskDetailsComponent implements OnInit {
  @Input()
  task: Task;
  isTaskPictureLoading = true;

  constructor() {}

  ngOnInit(): void {}

  onTaskPictureLoaded() {
    this.isTaskPictureLoading = false;
  }
}
