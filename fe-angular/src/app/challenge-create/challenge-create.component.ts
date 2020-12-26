import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { UploadedImage } from '../uploaded-image';

@Component({
  selector: 'app-challenge-create',
  templateUrl: './challenge-create.component.html',
  styleUrls: ['./challenge-create.component.sass'],
})
export class ChallengeCreateComponent implements OnInit {
  challengeImageUrl: string;
  challengeFormGroup: FormGroup;

  constructor(private _fb: FormBuilder) {}

  ngOnInit(): void {
    this.challengeFormGroup = this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      tasks: this._fb.array([this._generateTaskFormGroup()]),
    });
  }

  onUploadChallengePicture(response: Observable<UploadedImage>) {
    response.subscribe((uploadedImage) => {
      console.log(uploadedImage);
      this.challengeImageUrl =
        environment.staticStorageUrl + uploadedImage.path;
    });
  }

  private _generateTaskFormGroup(): FormGroup {
    return this._fb.group({
      title: ['', Validators.required],
      description: ['', Validators.required],
      type: ['', Validators.required],
    });
  }
}
