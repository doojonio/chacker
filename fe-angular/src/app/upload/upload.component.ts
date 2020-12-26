import { Observable } from 'rxjs';

import {
  Component,
  EventEmitter,
  HostListener,
  OnInit,
  Output,
} from '@angular/core';

import { UploadService } from '../upload.service';
import { UploadedImage } from '../uploaded-image';

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.sass'],
})
export class UploadComponent implements OnInit {
  @Output()
  fileUploaded = new EventEmitter<Observable<UploadedImage>>();

  constructor(private _uploadService: UploadService) {}

  ngOnInit(): void {}

  @HostListener('dragover', ['$event'])
  public test(event: DragEvent) {
    event.preventDefault();
  }

  @HostListener('drop', ['$event'])
  public uploadFile(event: DragEvent) {
    event.preventDefault();
    const files = event.dataTransfer.files;

    if (files.length === 1) {
      const response: Observable<UploadedImage> = this._uploadService.uploadImage(
        files[0]
      );
      this.fileUploaded.emit(response);
    }
  }
}
