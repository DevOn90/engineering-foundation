import { Component, inject, OnInit } from '@angular/core';
import { RouterLink } from "@angular/router";
import { ApiService } from '../../../../core/services/api';

@Component({
  selector: 'app-health-page',
  imports: [RouterLink],
  templateUrl: './health-page.html',
  styleUrl: './health-page.scss',
})
export class HealthPage implements OnInit {

  private api = inject(ApiService);
  public message = '';

  ngOnInit(): void {
    this.api
    .get<{message:string}>('/api/v1/health')
    .subscribe( res => {
       this.message = res.message
    })
  }
}
