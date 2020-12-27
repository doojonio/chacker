import { Observable } from 'rxjs';

import {
  Component,
  ElementRef,
  EventEmitter,
  HostListener,
  OnInit,
  Output,
  ViewChild,
} from '@angular/core';

import { UploadService } from '../upload.service';
import { UploadedImage } from '../uploaded-image';

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.scss'],
})
export class UploadComponent implements OnInit {
  @Output()
  fileUploaded = new EventEmitter<Observable<UploadedImage>>();

  @ViewChild('fileInput')
  fileInput: ElementRef;

  constructor(private _uploadService: UploadService) {}

  ngOnInit(): void {}

  public openFileExplorer() {
    const event = new MouseEvent('click', { bubbles: false });
    this.fileInput.nativeElement.dispatchEvent(event);
  }

  @HostListener('dragover', ['$event'])
  public test(event: DragEvent) {
    event.preventDefault();
  }

  @HostListener('drop', ['$event'])
  public uploadDroppedFile(event: DragEvent) {
    event.preventDefault();
    const files = event.dataTransfer.files;

    if (files.length === 1) {
      this._uploadFile(files[0]);
    }
  }

  public uploadSelectedFile(files: FileList) {
    if (files.length === 1) {
      this._uploadFile(files.item(0));
    }
  }

  private _uploadFile(file: File) {
    const response: Observable<UploadedImage> = this._uploadService.uploadImage(
      file
    );
    this.fileUploaded.emit(response);
  }
}
