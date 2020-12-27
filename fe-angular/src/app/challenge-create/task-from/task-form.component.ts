import { Observable } from 'rxjs';
import { Task } from 'src/app/task';
import { UploadedImage } from 'src/app/uploaded-image';
import { environment } from 'src/environments/environment';

import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-task-form',
  templateUrl: './task-form.component.html',
  styleUrls: ['./task-form.component.scss']
})
export class TaskFormComponent implements OnInit {
  @Output()
  taskCreated = new EventEmitter<Task>();

  taskForm: FormGroup;
  uploadedImage: UploadedImage;

  constructor(
    private _fb: FormBuilder,
  ) { }

  ngOnInit(): void {
    this.taskForm = this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      type: ['once', Validators.required],
    });
  }

  createTask() {
    if (!this.taskForm.valid || !this.uploadedImage) {
      return;
    }

    const newTask = this.taskForm.value as Task;
    newTask.picture = this.uploadedImage;
    newTask.pictureUrl = environment.staticStorageUrl + newTask.picture.path;

    this.taskCreated.emit(newTask);
  }

  addImage(uploadedImage$: Observable<UploadedImage>) {
    uploadedImage$.subscribe(uploadedImage => {
      this.uploadedImage = uploadedImage;
    });
  }

  resetImage() {
    this.uploadedImage = null;
  }
}
