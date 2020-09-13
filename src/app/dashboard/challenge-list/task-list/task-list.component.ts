import { Component, Input, OnInit } from '@angular/core';
import { Task } from '../../../entities/challenge-common';

@Component({
  selector: 'app-task-list',
  templateUrl: './task-list.component.html',
  styleUrls: ['./task-list.component.sass']
})
export class TaskListComponent implements OnInit {
  @Input() tasks: Task[];

  constructor() { }

  ngOnInit(): void {
  }

}
