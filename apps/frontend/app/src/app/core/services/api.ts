import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  
  private http = inject(HttpClient);

  get<T>(path: string){
    return this.http.get<T>(path);
  }
}
