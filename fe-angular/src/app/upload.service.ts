import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { UploadedImage } from './uploaded-image';

@Injectable({
  providedIn: 'root',
})
export class UploadService {
  constructor(private _http: HttpClient) {}

  uploadImage(file: File): Observable<UploadedImage> {
    const urlForUploading = environment.backendUrl + '/api/upload/image';
    const formData = new FormData();
    formData.append('image', file, file.name);
    return this._http.post<UploadedImage>(urlForUploading, formData).pipe(
      tap((image) => {
        this._fixSnakecaseFields(image);
        image.storageUrl = environment.staticStorageUrl + image.path;
      })
    );
  }

  private _fixSnakecaseFields(uploadedImage: UploadedImage) {
    uploadedImage.uploadTime = uploadedImage.upload_time;
  }
}
