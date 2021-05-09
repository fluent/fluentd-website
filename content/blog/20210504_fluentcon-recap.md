## FluentCon 2021 Recap & Updates

We’ve just had a series of amazing sessions from leaders and friends in the Fluentd & Fluent Bit community from Chronosphere, Calyptia, Nieman and Marcus, Cisco, Microsoft, Amazon, SAP,  Zendesk and many community members & attendees from all over the world. There were variety of use cases, production challenges and solutions, performance optimization with great benchmark results at scale. Hope you enjoyed the conference and here are some notes for your review. 

### 1st FluentCon co-located with KubeCon

1st FluentCon, co-located with KubeCon Europe, had a variety of topics covered starting from Fluentd & Fluent Bit updates including native metrics support and followed by great talks. 

### Observability for operation at scale
We really felt the vendor neutral observability is getting more momentum and exciting activities in "Tracing", "Metrics" and "Logs" are coming together to bring the operation at scale to the next level. 

### Fluentd and Fluent Bit Updates
1. **Fluentd turns 10 in June!** Happy 10th birthday!
2. Fluent Bit is being deployed **over 2 million times a day**.
3. **Conrainer deployments** are **10x higher** than package deployments.
4. New release of **Fluent Bit 1.7** and **Fluentd 1.12**
 - Fluent Bit multi-workers, new SSL library, and improved I/O disk performance (**Available now!**)

### More Transparency, Accessibility and Neutrality for Observability
1. New ways to engage the community with [**https://discuss.fluentd.org**][1]

[1]: https://discuss.fluentd.org

2. Building for more Vendor Nertality with additional plugins.
 - New **native support for Metric** handling (**Available now!**)
 - Native integration with **Prometheus** (**Available now!**)
 - Stream Processor support to Extract Metrics from Log data (Coming soon)
 - Support for Open Telemetry Protocol (OLTP) (Coming later this year.)
 
### Simpler Plugin Development 
1. New **WebAssembly** integration with Fluent Bit (Coming later this year.)
2. Write plugins the language you want. Keep the blazing fast performance.
 
### Thanks to the foundation and conference speakers and sponsors
We would like to thank Cloud Native Computing Foundation and conference oganizer team for all the community effort making people meet and discuss in this challenging moment. We also thank all the amazing speakers and sponsors to support the 1st FluentCon.
Here is the list of speakers and sponsors.
1. [**Opening Remarks and Keynote**][2]
 - Martin Mao, CEO/Co-founder at Chronosphere
 - Anurag Gupta, Product Management at Calyptia

[2]: https://static.sched.com/hosted_files/fluentconeu21/0d/FluentCon%20Presentation.pdf

2. [**Fluent Bit - Swiss Army Tool of Observability Data Ingestion**][3]
 - [**Michael Marshall**][3], Sr. SRE at Neiman Marcus
 - Projects : [**Fluent Bit - Data Observability Platform**][4] & [**Fluent Bit Output Plugin for Log Derived Metrics**][5]


3. [**Exporting your trace telemetry with OpenTelemetry and Fluent Bit**][6] 
 - Aditya Jagdishkumar Prajapati

[6]: https://static.sched.com/hosted_files/fluentconeu21/9b/FluentCon.pdf

4. [**Logging Operator the Cloud Native Fluent Ecosystem**][7]
 - Sandor Guba, Cisco
 - Project : [**Logging operator**][8]

[7]: https://static.sched.com/hosted_files/fluentconeu21/14/LoggingOperatorTheCloudNativeFluentEcosystem_SandorGuba_4May_v1.pdf
[8]: https://github.com/banzaicloud/logging-operator

5. [**Lightning Talk: Scaling the Fluent Bit Kubernetes Filter in very large clusters**][9]
 - Drew Zhang & Nithish Kumar Murcherla, Amazon

[9]: https://static.sched.com/hosted_files/fluentconeu21/b0/ScaleKubernetesFilterInVeryLargeclusters_DrewZhang%26NithishKumar%20Murcherla_4May.pptx.pdf

6. [**Lightning Talk: Fluentd as syslog drain for CloudFoundry**][10]
 - Karsten Schnitter, SAP SE

[10]: https://static.sched.com/hosted_files/fluentconeu21/d7/FluentdAsSyslogDrainForCloudFoundry_KarstenSchnitter_4May.pdf
[12]: https://github.com/microsoft/fluentbit-containerd-cri-o-json-log

7. [**Lightning Talk: Fluentd at Scale; Keys to successful Logging Syndication**][11]
 - Fred Moyer, SRE Observability Economist, Zendesk

[11]: https://static.sched.com/hosted_files/fluentconeu21/ac/FluentdAtScaleKeysToSuccessfulLoggingSyndication_FredMoyer_4May_v1.pdf

8. Lightning Talk: Parsing CRI JSON logs with Fluent Bit
 - Bart Robertson & Joseph Fultz, Microsoft
 - Project : [**Fluent Bit with containerd, CRI-O and JSON**][12]

9. [**Customized Cloud Native Logging: Fluent Bit in Open Service Mesh**][13]
 - Sanya Kochhar, Software Engineer, Azure at Microsoft

[13]: https://static.sched.com/hosted_files/fluentconeu21/8f/Customized%20Cloud%20Native%20Logging.pdf

10. [**Scaling Log Collection with Fluent Bit**][14]
 - Wesley Pettit & Ugur Kira, Amazon

[14]: https://static.sched.com/hosted_files/fluentconeu21/f6/Scaling_Log_Collection_with_Fluent_Bit.pdf

11. [**Noise Cancelling Headphones for Fluent Bit - Powered by Lua**][15]
 - Matt Lehman at GreyNoise Intelligence Inc.

[15]: https://static.sched.com/hosted_files/fluentconeu21/4c/Noise%20Cancelling%20Headphones%20for%20Fluent%20Bit%20-%20Powered%20by%20Lua.pdf

12. [**Keynote: DevSecOps in the US Air Force and Closing Remarks**][16]
 - Nicolas Chaillan, Air Force Chief Software Office, US Air Force
 - Anurag Gupta & Eduardo Silva, Calyptia

[16]: https://static.sched.com/hosted_files/fluentconeu21/cd/DoD%20Enterprise%20DevSecOps%20Initiative%20-%20Kubecon%202.0.pptx.pdf
[3]: https://static.sched.com/hosted_files/fluentconeu21/01/FluentBitSwissArmyToolOfObservabilityDataIngestion_MichaelMarshall_4May_v1.pdf
[5]: https://github.com/neiman-marcus/fluent-bit-out-prometheus-metrics
[4]: https://github.com/neiman-marcus/fluent-bit-data-observability-platform
[3]: https://mrmikemarshall.github.io/

Platinum Sponsor : [**Fluentd Subscription Network**][17] by ITOCHU Techno-Solution America, Inc.

[17]: https://fluentd.ctc-america.com

TAG: Observability Fluentd FluentBit
AUTHOR: hisa
