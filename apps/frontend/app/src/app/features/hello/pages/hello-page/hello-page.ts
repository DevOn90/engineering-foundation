import { Component, inject, OnInit } from '@angular/core';
import { ApiService } from '../../../../core/services/api';
import { RouterLink } from "@angular/router";

@Component({
  selector: 'app-hello-page',
  imports: [RouterLink],
  templateUrl: './hello-page.html',
  styleUrl: './hello-page.scss',
})
export class HelloPage implements OnInit {

  private api = inject(ApiService);
  
  message = '';

  ngOnInit(): void {
    this.api
    .get<{message:string}>('/api/v1/hello')
    .subscribe(res => {
      this.message = res.message
    });
  }
}
