
import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as iam from 'aws-cdk-lib/aws-iam';
import { ARecord, HostedZone, RecordTarget } from 'aws-cdk-lib/aws-route53';
import { Construct } from 'constructs';
import { AmiImage, DNSConfig } from '../bin/infra';

export interface ResizeZKProps extends cdk.StackProps {
  vpcId: string;
  sshKeyName: string;
  amiImage: AmiImage;
  dns: DNSConfig;
  whiteListedIps: string;
}

export class ResizeZK extends cdk.Stack {
  constructor(scope: Construct, id: string, props: ResizeZKProps) {
    super(scope, id, props);


    const vpc = ec2.Vpc.fromLookup(this, 'mvp-vpc-resize', {
      vpcId: props.vpcId,
    });

    const iamRole = new iam.Role(this, 'Resize-Iam', {
      roleName: 'resizezkserver-ec2-role',
      assumedBy: new iam.ServicePrincipal('ec2.amazonaws.com'),
    });


    const securityGroup = new ec2.SecurityGroup(this, 'Resize-SecurityGroup', {
      securityGroupName: 'resizezkserver-ec2-sg',
      vpc,
      allowAllOutbound: true, // Can be set to false
    });


    securityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      'allow HTTP access from anywhere',
    );

    securityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(8080),
      'allow HTTP access from anywhere',
    );

    securityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(443),
      'allow HTTPS access from anywhere',
    );

    // allow these ports for whiteListedIps
    props.whiteListedIps.split(',').forEach((ip) => {
      securityGroup.addIngressRule(ec2.Peer.ipv4(ip), ec2.Port.tcp(22), 'ssh access');
    });

    //ec2 instance with userdata
    const resizezkserverInstance = new ec2.Instance(this, 'Instance', {
      instanceName: 'resizezkserver-instance',
      vpc,
      securityGroup,
      machineImage: ec2.MachineImage.genericLinux(props.amiImage),
      keyName: props.sshKeyName,
      role: iamRole,
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T2, ec2.InstanceSize.MICRO),
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC,
      },
    });


    // output the DNS where you can access your instance
    new cdk.CfnOutput(this, 'InstancePublicDnsName', {
      value: resizezkserverInstance.instancePublicDnsName,
    });

    const hostedZone = HostedZone.fromHostedZoneAttributes(this, 'zone', {
      hostedZoneId: props.dns.hostedZoneId,
      zoneName: props.dns.zoneName,
    });

    const resizezkserverRecord = new ARecord(this, `ResizeZKServer-Alias`, {
      recordName: `zk`,
      zone: hostedZone,
      comment: `DNS Alias for ResizeZK`,
      target: RecordTarget.fromIpAddresses(resizezkserverInstance.instancePublicIp),
    });
  }
}
