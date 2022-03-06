
import { InjectionToken } from '@angular/core';
import {create} from 'ipfs-http-client';

export const ipfsToken = new InjectionToken('The IPFS Token', {
  providedIn: 'root',

  // safe to put in the 'root',as it
  // will not throw any error until we call IPFS API
  factory: () => create({
    host: 'ipfs.infura.io',
    port: 5001,
    protocol: 'https'
  })

});

