import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';


@Injectable({
  providedIn: 'root',
})
export class ApiService {
  
  private http = inject(HttpClient);

  get<T>(path: string){
    return this.http.get<T>(`${environment.apiBaseUrl}${path}`);
  }
}
