#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { ResizeZK } from '../lib/resize-stack';
import * as dotenv from 'dotenv';

dotenv.config();

export interface AmiImage {
  [key: string]: string;
}

export interface DNSConfig {
  hostedZoneId: string;
  zoneName: string;
}

export interface EnvironmentConfig {
  account: string;
  region: string;
}

export interface StackConfig {
  vpcId: string;
  amiImage: AmiImage;
  dns: DNSConfig;
  env: EnvironmentConfig;
  sshKeyName: string;
  // comma separated list of IPs
  whiteListedIps: string;
}

const vpcId = process.env.VPC_ID as string;
const REGION = process.env.REGION as string;
const ACCOUNT = process.env.ACCOUNT as string;
const HOSTED_ZONE_ID = process.env.HOSTED_ZONE_ID as string;
const ZONE_NAME = process.env.ZONE_NAME as string;
const WHITE_LISTED_IPS = process.env.WHITE_LISTED_IPS as string;
const AMI_IMAGE_EU = process.env.AMI_IMAGE_EU as string;
const SSH_KEY_NAME = process.env.SSH_KEY_NAME as string;

const dns: DNSConfig = {
  hostedZoneId: HOSTED_ZONE_ID,
  zoneName: ZONE_NAME,
};

const envEU: EnvironmentConfig = {
  account: ACCOUNT,
  region: REGION,
};

const amiImage: AmiImage = {
  [REGION]: AMI_IMAGE_EU,
};

const app = new cdk.App();

const stackConfig: StackConfig = {
  vpcId,
  amiImage: amiImage,
  dns,
  env: envEU,
  sshKeyName: SSH_KEY_NAME,
  whiteListedIps: WHITE_LISTED_IPS,
};

new ResizeZK(app, 'ResizeZKImageStack', stackConfig);
