type file = { name: string; text: string }
let files = [{ name = "elpi-checker.elpi"; text = "LyogZWxwaTogZW1iZWRkZWQgbGFtYmRhIHByb2xvZyBpbnRlcnByZXRlciAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwovKiBsaWNlbnNlOiBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgVmVyc2lvbiAyLjEgb3IgbGF0ZXIgICAgICAgICAgICovCi8qIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8KCiUgU2ltcGxlIHR5cGUgY2hlY2tlciBmb3IgbGFtYmRhLVByb2xvZyBwcm9ncmFtcwphY2N1bXVsYXRlIGVscGlfcXVvdGVkX3N5bnRheC4KCiUgLS0tLS0tLS0tIEhPQVMgb3IgcHJvZ3JhbXMgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKa2luZCB0eXAgdHlwZS4gJSUlJSUgdHlwZXMgJSUlJSUlCgp0eXBlIGFycm93IHR5cCAtPiB0eXAgLT4gdHlwLgp0eXBlIHRjb25zdCBzdHJpbmcgLT4gdHlwLgp0eXBlIHRhcHAgbGlzdCB0eXAgLT4gdHlwLgp0eXBlIHByb3AgdHlwLgp0eXBlIGZvcmFsbCAodHlwIC0+IHR5cCkgLT4gdHlwLiAlIHBvbHltb3JwaGljIHR5cGUgZGVjbGFyYXRpb25zCnR5cGUgY3R5cGUgc3RyaW5nIC0+IHR5cC4KCiUgLS0tLS0tLS0tIHV0aWxzICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCmlmIEIgVCBfIDotIEIsICEsIFQuCmlmIF8gXyBFIDotIEUuCgppdGVyIF8gW10uCml0ZXIgRiBbWCB8IFhTXSA6LSBGIFgsIGl0ZXIgRiBYUy4KCiUgLS0tLS0tLS0tIGVycm9yIHJlcG9ydGluZyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCmtpbmQgZXJyIHR5cGUuCnR5cGUgdHlwZS1lcnIgdGVybSAtPiB0eXAgLT4gdHlwIC0+IGVyci4KdHlwZSB3cm9uZy1hcml0eSB0ZXJtIC0+IHR5cCAtPiBsaXN0IHRlcm0gLT4gZXJyLgp0eXBlIHVua25vd24gdGVybSAtPiBlcnIuCnR5cGUgYXNzZXJ0IHByb3AgLT4gZXJyIC0+IHByb3AuCgp0eXBlIGVycm9yIGxpc3Qgc3RyaW5nIC0+IHByb3AuCjpuYW1lICJkZWZhdWx0LXR5cGVjaGVja2luZy1lcnJvciIKZXJyb3IgTXNnIDotIGl0ZXIgKHhcIGpzX2VyciAiQ2hlY2tlciIgeCkgTXNnLgoKdHlwZSB3YXJuaW5nIHN0cmluZyAtPiBwcm9wLgo6bmFtZSAiZGVmYXVsdC10eXBlY2hlY2tpbmctd2FybmluZyIKd2FybmluZyBNc2cgOi0ganNfd2FybiAiQ2hlY2tlciIgTXNnLgoKYXNzZXJ0IFAgXyA6LSBQLCAhLgphc3NlcnQgXyAodHlwZS1lcnIgVCBUeSBFVHkpIDotICEsCiAgY2hlY2tpbmcgTE9DLCB0ZXJtX3RvX3N0cmluZyBMT0MgU0xPQywKICBNU0cgaXMgU0xPQyBeICIgRXJyb3I6ICIgXiB7cHAgVH0gXiAiIGhhcyB0eXBlICIgXiB7cHB0IFR5fSBeCiAgICAgICAgICIgYnV0IGlzIHVzZWQgd2l0aCB0eXBlICIgXiB7cHB0IEVUeX0sCiAgZXJyb3IgW01TR10uCmFzc2VydCBfICh3cm9uZy1hcml0eSBUIFR5IEEpIDotICEsCiAgY2hlY2tpbmcgTE9DLCB0ZXJtX3RvX3N0cmluZyBMT0MgU0xPQywKICBNU0cgaXMgU0xPQyBeICIgRXJyb3I6ICIgXiB7cHAgVH0gXiAiIGhhcyB0eXBlICIgXiB7cHB0IFR5fSBeCiAgICAgICAgICAiIGJ1dCBpcyBhcHBsaWVkIHRvICIgXiB7cHAtbGlzdCBBfSwKICBlcnJvciBbTVNHXS4KYXNzZXJ0IF8gKHVua25vd24gVCkgOi0gISwKICBjaGVja2luZyBMT0MsIHRlcm1fdG9fc3RyaW5nIExPQyBTTE9DLAogIE1TRyBpcyBTTE9DIF4gIiBXYXJuaW5nOiAiIF4ge3BwIFR9IF4gIiBpcyB1bmRlY2xhcmVkIiwKICB3YXJuaW5nIE1TRy4KCm1lbSBYIFsgWCB8IF8gXSA6LSAhLgptZW0gWCBbIF8gfCBZU10gOi0gbWVtIFggWVMuCgpzdGFzaC1uZXcgRSBTIDotIG9wZW5fc2FmZSBFIEwsICggbWVtIFMgTCA7IHN0YXNoX2luX3NhZmUgRSBTICksICEuCgpyZXBvcnQtYWxsLWZhaWx1cmVzLWlmLW5vLXN1Y2Nlc3MgUCA6LQogIG5ld19zYWZlIEUsCiAgKCgocGkgTUxcIGVycm9yIE1MIDotICEsIGl0ZXIgKHN0YXNoLW5ldyBFKSBNTCwgZmFpbCkgPT4gUCkKICAgOwogICAoZXJyb3Ige29wZW5fc2FmZSBFfSkpLgpyZXBvcnQtYWxsLWZhaWx1cmVzLWFuZC1mYWlsLWlmLW5vLXN1Y2Nlc3MgUCA6LQogIG5ld19zYWZlIEUsCiAgKCgocGkgTUxcIGVycm9yIE1MIDotICEsIGl0ZXIgKHN0YXNoLW5ldyBFKSBNTCwgZmFpbCkgPT4gUCkKICAgOwogICAoZXJyb3Ige29wZW5fc2FmZSBFfSwgZmFpbCkpLgoKbW9kZSAocHAgaSBvKS4KdHlwZSBwcCB0ZXJtIC0+IHN0cmluZyAtPiBwcm9wLgpwcCAoYXBwIEwpIFQxIDotICEsIHBwLWxpc3QgTCBULCBUMSBpcyAiKCIgXiBUIF4gIikiLgpwcCAobGFtIEYpIFQgOi0gISwgcGkgeFwgdGVybV90b19zdHJpbmcgeCBYUywgKHBwIHggWFMgOi0gISkgPT4gcHAgKEYgeCkgVC4KcHAgKGNvbnN0ICJkaXNjYXJkIikgIl8iIDotICEuCnBwIChjb25zdCBTKSBTIDotICEuCnBwIChjZGF0YSBYKSBTIDotICEsIHRlcm1fdG9fc3RyaW5nIFggUy4KcHAgWCBYUyA6LSB0ZXJtX3RvX3N0cmluZyBYIFhTLgoKbW9kZSAocHAtbGlzdCBpIG8pLgpwcC1saXN0IFtYXSBZIDotICEsIHBwIFggWS4KcHAtbGlzdCBbWHxYU10gWSA6LSBwcC1saXN0IFhTIFhTUywgcHAgWCBYVCwgWSBpcyBYVCBeICIgIiBeIFhTUy4KcHAtbGlzdCBbXSAiIi4KCm1vZGUgKHBwdCBpIG8pLgpwcHQgKGN0eXBlIFgpIFggOi0gIS4KcHB0ICh0Y29uc3QgWCkgWCA6LSAhLgpwcHQgKHRhcHAgTCkgWCA6LSAhLCBwcHQtbGlzdCBMIFQsIFggaXMgIigiIF4gVCBeICIpIi4KcHB0IChhcnJvdyBBIEIpIFMgOi0gISwgcHB0IEEgQVMsIHBwdCBCIEJTLCBTIGlzICIoIiBeIEFTIF4gIiAtPiAiIF4gQlMgXiAiKSIuCnBwdCBYIFkgOi0gdGVybV90b19zdHJpbmcgWCBZLgoKbW9kZSAocHB0LWxpc3QgaSBvKS4KcHB0LWxpc3QgW1hdIFkgOi0gISwgcHB0IFggWS4KcHB0LWxpc3QgW1h8WFNdIFkgOi0gcHB0LWxpc3QgWFMgWFNTLCBwcHQgWCBYVCwgWSBpcyBYVCBeICIgIiBeIFhTUy4KcHB0LWxpc3QgW10gIiIuCgolIC0tLS0tLS0tLSB0eXBpbmcgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCm1vZGUgKHVuaWYgaSBpKS4KCnVuaWYgKHRjb25zdCAiYW55IikgXyA6LSAhLgp1bmlmIF8gKHRjb25zdCAiYW55IikgOi0gIS4KdW5pZiAodGFwcCBbXSkgKHRhcHAgW10pLgp1bmlmICh0YXBwIFtYfEwxXSkgKHRhcHAgW1l8TDJdKSA6LSB1bmlmIFggWSwgdW5pZiAodGFwcCBMMSkgKHRhcHAgTDIpLgp1bmlmICh0Y29uc3QgWCkgKHRjb25zdCBYKS4KdW5pZiAoY3R5cGUgWCkgKGN0eXBlIFgpLgp1bmlmIHByb3AgcHJvcC4KdW5pZiAoYXJyb3cgQTEgQjEpIChhcnJvdyBBMiBCMikgOi0gdW5pZiBBMSBBMiwgdW5pZiBCMSBCMi4KdW5pZiAodXZhciBhcyBYKSBZIDotIFggPSBZLgp1bmlmIFkgKHV2YXIgYXMgWCkgOi0gWCA9IFkuCgptb2RlIChvZiBpIG8pLgoKb2YgKGNkYXRhIENEYXRhKSBUeSA6LQogIGlzX2NkYXRhIENEYXRhIENUeSwgISwgYXNzZXJ0ICh1bmlmIFR5IENUeSkgKHR5cGUtZXJyIChjZGF0YSBDRGF0YSkgQ1R5IFR5KS4KCm9mIChhcHAgW0hEfEFSR1NdKSBUWSA6LSAhLCAKICByZXBvcnQtYWxsLWZhaWx1cmVzLWlmLW5vLXN1Y2Nlc3MgJSBIRCBtYXkgaGF2ZSBtdWx0aXBsZSB0eXBlcwogICAob2YgSEQgSERUWSwgb2YtYXBwIEhEVFkgQVJHUyBUWSBIRCAoRG9uZSAtIERvbmUpKS4Kb2YgKGxhbSBGKSAoYXJyb3cgVCBCKSA6LSAhLCBwaSB4XAogIChvZiB4IFQgOi0gISkgPT4gb2YgKEYgeCkgQi4KCm9mIChjb25zdCAicGkiKSAoYXJyb3cgKGFycm93IEFfIHByb3ApIHByb3ApIDotICEuCm9mIChjb25zdCAic2lnbWEiKSAoYXJyb3cgKGFycm93IEFfIHByb3ApIHByb3ApIDotICEuCm9mIChjb25zdCAiZGlzY2FyZCIpIEFfIDotICEuCgpvZiBJZCBfIDotIGFzc2VydCAoa25vd24gSWQpICh1bmtub3duIElkKSwgZmFpbC4KCm1vZGUgKG9mLWFwcCBpIGkgbyBvIG8pLgoKOmlmICJERUJVRzpDSEVDS0VSIgpvZi1hcHAgVHkgQXJncyBUZ3QgSGQgXyA6LQogIHByaW50IHtjb3VudGVyICJydW4ifSAib2YtYXBwIiB7cHAgSGR9ICI6IiB7cHAgVHl9ICJAIiB7cHAtbGlzdCBBcmdzfSAiPSIge3BwIFRndH0sIGZhaWwuCgpvZi1hcHAgKHRhcHAgW3Rjb25zdCAidmFyaWFkaWMiLCBULCBfXSBhcyBWKSBbWHxYU10gVEdUIEhEIChCIC0gQlQpIDotICEsCiAgb2YgWCBUWCwgYXNzZXJ0ICh1bmlmIFQgVFgpICh0eXBlLWVyciBYIFRYIFQpLCBCVCA9IFggOjogVEwsIG9mLWFwcCBWIFhTIFRHVCBIRCAoQiAtIFRMKS4Kb2YtYXBwICh0YXBwIFt0Y29uc3QgInZhcmlhZGljIiwgXywgVFNdKSBbXSBUR1QgSEQgKEQgLSBbXSkgOi0gISwKICBhc3NlcnQgKHVuaWYgVEdUIFRTKSAodHlwZS1lcnIgKGFwcCBbSER8RF0pIFRTIFRHVCkuCm9mLWFwcCAoYXJyb3cgVCBUUykgW1h8WFNdIFRHVCBIRCAoQiAtIEJUKSA6LSAhLAogIG9mIFggVFgsIGFzc2VydCAodW5pZiBUIFRYKSAodHlwZS1lcnIgWCBUWCBUKSwgQlQgPSBYIDo6IFRMLCBvZi1hcHAgVFMgWFMgVEdUIEhEIChCIC0gVEwpLgpvZi1hcHAgKHV2YXIgYXMgQVJSKSAgW1h8WFNdIFRHVCBIRCAoQiAtIEJUKSA6LSAhLAogIG9mIFggVCwgQVJSID0gYXJyb3cgVCBUUywgQlQgPSBYIDo6IFRMLCBvZi1hcHAgVFMgWFMgVEdUIEhEIChCIC0gVEwpLgpvZi1hcHAgVHkgW10gVEdUIEhEIChEIC0gW10pIDotICEsCiAgYXNzZXJ0ICh1bmlmIFRHVCBUeSkgKHR5cGUtZXJyIChhcHAgW0hEfERdKSBUeSBUR1QpLgpvZi1hcHAgKHV2YXIgYXMgVHkpICBbXSBUR1QgSEQgKEQgLSBbXSkgOi0gISwKICBhc3NlcnQgKHVuaWYgVEdUIFR5KSAodHlwZS1lcnIgKGFwcCBbSER8RF0pIFR5IFRHVCkuCgpvZi1hcHAgVHkgQXJncyBfIEhEIChEIC0gW10pIDotICEsCiAgYXNzZXJ0IGZhbHNlICh3cm9uZy1hcml0eSAoYXBwIFtIRHxEXSkgVHkgQXJncykuCgpvZi1jbGF1c2UgW058TlNdIChhcmcgQykgOi0gISwgcGkgeFwgCiAocHAgeCBOIDotICEpID0+IChwaSBUZlwgb2YgeCBUZiA6LSAhLCBhc3NlcnQgKHVuaWYgVCBUZikgKHR5cGUtZXJyIHggVCBUZikpID0+CiBvZi1jbGF1c2UgTlMgKEMgeCkuCm9mLWNsYXVzZSBbXSAoYXJnIEMpIDotICEsIHBpIHhcIAogKHBpIFRmXCBvZiB4IFRmIDotICEsIGFzc2VydCAodW5pZiBUIFRmKSAodHlwZS1lcnIgeCBUIFRmKSkgPT4KIG9mLWNsYXVzZSBbXSAoQyB4KS4Kb2YtY2xhdXNlIF8gQyA6LSBvZiBDIFRDLCBhc3NlcnQgKHVuaWYgVEMgcHJvcCkgKHR5cGUtZXJyIEMgVEMgcHJvcCkuCgp0eXBlIGNoZWNraW5nIChjdHlwZSAibG9jIikgLT4gcHJvcC4KCjppZiAiREVCVUc6Q0hFQ0tFUiIKbG9nLXRjLWNsYXVzZSBMb2MgUXVlcnkgOi0gISwgcHJpbnQge2NvdW50ZXIgInJ1biJ9ICJ0eXBlY2hlY2siIExvYyBRdWVyeS4KbG9nLXRjLWNsYXVzZSBfIF8uCgp0eXBlY2hlY2sgW10gKGNsYXVzZSBMb2MgTmFtZXMgUXVlcnkpIDotCiAgbG9nLXRjLWNsYXVzZSBMb2MgUXVlcnksCiAgY2hlY2tpbmcgTG9jID0+CiAgICByZXBvcnQtYWxsLWZhaWx1cmVzLWFuZC1mYWlsLWlmLW5vLXN1Y2Nlc3MgKG9mLWNsYXVzZSBOYW1lcyBRdWVyeSkuCnR5cGVjaGVjayBbIChjbGF1c2UgTG9jIE5hbWVzIENsYXVzZSkgfFJlc3RdIFEgOi0KICBsb2ctdGMtY2xhdXNlIExvYyBDbGF1c2UsCiAgY2hlY2tpbmcgTG9jID0+CiAgICByZXBvcnQtYWxsLWZhaWx1cmVzLWFuZC1mYWlsLWlmLW5vLXN1Y2Nlc3MgKG9mLWNsYXVzZSBOYW1lcyBDbGF1c2UpLCAhLAogIHR5cGVjaGVjayBSZXN0IFEuCgptb2RlIChyZWZyZXNoIGkgbykuCnJlZnJlc2ggKGZvcmFsbCBGKSBUIDotICEsIHJlZnJlc2ggKEYgRlJFU0hfKSBULgpyZWZyZXNoICh0Y29uc3QgImFueSIpIEZSRVNIXyA6LSAhLgpyZWZyZXNoIFggWC4KCmtpbmQgZW50cnkgdHlwZS4KdHlwZSBgOiB0ZXJtIC0+IHR5cCAtPiBlbnRyeS4KCm1lbS1hc3NvYyBYIFtYIGA6IF8gfCBfXSA6LSAhLgptZW0tYXNzb2MgWCBbIF8gfCBYU10gOi0gbWVtLWFzc29jIFggWFMuCgpzYWZlLWRlc3QtYXBwIChhcHAgW1ggfCBBXSkgWCBBIDotICEuCnNhZmUtZGVzdC1hcHAgWCBYIFtdLgoKbWFjcm8gQHZkYXNoIDotICI6LSIuCgpjb2xsZWN0LXByZWRpY2F0ZXMtY2xhdXNlIChhcmcgRikgQWNjIFJlcyA6LSAhLAogIHBpIHhcIGNvbGxlY3QtcHJlZGljYXRlcy1jbGF1c2UgKEYgeCkgQWNjIFJlcy4KY29sbGVjdC1wcmVkaWNhdGVzLWNsYXVzZSAoYXBwIFtjb25zdCBAdmRhc2gsIEhEIHwgX10pIEFjYyBSZXMgOi0gISwKICBzYWZlLWRlc3QtYXBwIEhEIEMgXywgaWYgKG1lbS1hc3NvYyBDIEFjYykgKFJlcyA9IEFjYykgKFJlcyA9IFtDIGA6IF8gfCBBY2NdKS4KY29sbGVjdC1wcmVkaWNhdGVzLWNsYXVzZSBIRCBBY2MgUmVzIDotCiAgc2FmZS1kZXN0LWFwcCBIRCBDIF8sIGlmIChtZW0tYXNzb2MgQyBBY2MpIChSZXMgPSBBY2MpIChSZXMgPSBbQyBgOiBfIHwgQWNjXSkuCgpjb2xsZWN0LXByZWRpY2F0ZXMtcHJvZ3JhbSBbIChjbGF1c2UgXyBfIEMpIHwgUCBdIEFjYyBSZXMgOi0KICBjb2xsZWN0LXByZWRpY2F0ZXMtY2xhdXNlIEMgQWNjIEFjYzEsCiAgY29sbGVjdC1wcmVkaWNhdGVzLXByb2dyYW0gUCBBY2MxIFJlcy4KY29sbGVjdC1wcmVkaWNhdGVzLXByb2dyYW0gW10gWCBYLgoKbW9kZSAodW5kZXItZW52IGkgaSkuCgp0eXBlIGtub3duIHRlcm0gLT4gcHJvcC4KCnVuZGVyLWVudiBbXSBQIDotIFAuCnVuZGVyLWVudiBbIFggYDogUFQgfCBYUyBdIFAgOi0KICAlcHJpbnQgIkFzc3VtZSIgWCBQVCwKICAocGkgVHlcIG9mIFggVHkgOi0gcmVmcmVzaCBQVCBUeSkgPT4ga25vd24gWCA9PiB1bmRlci1lbnYgWFMgUC4KCnByZWQgcmV2IGk6bGlzdCBBLCBvOmxpc3QgQS4KcmV2IEwgUkwgIDotIHJldi1hdXggTCBbXSAgUkwuCnByZWQgcmV2LWF1eCBpOmxpc3QgQSwgaTpsaXN0IEEsIG86bGlzdCBBLgpyZXYtYXV4IFtYfFhTXSBBQ0MgUiA6LSByZXYtYXV4IFhTIFtYfEFDQ10gUi4KcmV2LWF1eCBbXSBMIEwuCgpzcGxpdCBbKGNvbnN0IEMpIGA6IFQgfCBUbF0gTEFDQyBSQUNDIEwgUiA6LSBzcGxpdCBUbCBbQyB8IExBQ0NdIFtUIHwgUkFDQ10gTCBSLgpzcGxpdCBbXSBMQUNDIFJBQ0MgTEFDQyBSQUNDLgoKCnR5cGVjaGVjay1wcm9ncmFtIFAgUSBEZWNsYXJlZFR5cGVzIDotCiAgY29sbGVjdC1wcmVkaWNhdGVzLXByb2dyYW0gUCBEZWNsYXJlZFR5cGVzIEFsbFR5cGVzLAogIHNwbGl0IEFsbFR5cGVzIFtdIFtdIE5TIFRTLCBqc190eXBlcyBOUyBUUywgISwKICBwcC1saXN0IERlY2xhcmVkVHlwZXMgVFBQLAogIHVuZGVyLWVudiB7cmV2IEFsbFR5cGVzfSAodHlwZWNoZWNrIFAgUSkuCgolIC0tLS0tLS0tLS0gd2FybmluZ3MgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgp0eXBlIGAtPiB0ZXJtIC0+IGludCAtPiBlbnRyeS4KdHlwZSB2YXJpYWJsZSB0ZXJtIC0+IHByb3AuCgptb2RlIChyZXBvcnQtbGluZWFyIGkpLgpyZXBvcnQtbGluZWFyIFtdLgpyZXBvcnQtbGluZWFyIFtWIGAtPiAxICsgdXZhciB8TlNdIDotICEsCiAgcHAgViBWTiwKICBpZiAobm90KHJleF9tYXRjaCAiXyIgVk4pLCBub3QocmV4X21hdGNoICIuKl8iIFZOKSkKICAgIChjaGVja2luZyBMT0MsIHRlcm1fdG9fc3RyaW5nIExPQyBTTE9DLAogICAgIE1TRyBpcyBTTE9DIF4iIFdhcm5pbmc6ICJeIFZOIF4iIGlzIGxpbmVhcjogbmFtZSBpdCBfIiBeIFZOIF4gIiAoZGlzY2FyZCkgb3IgIiBeIFZOIF4gIl8gKGZyZXNoIHZhcmlhYmxlKSIsCiAgICAgd2FybmluZyBNU0cpCiAgICB0cnVlLAogIHJlcG9ydC1saW5lYXIgTlMuCnJlcG9ydC1saW5lYXIgW1YgYC0+IHV2YXIgfE5TXSA6LQogIGNoZWNraW5nIExPQywgdGVybV90b19zdHJpbmcgTE9DIFNMT0MsCiAgTVNHIGlzIFNMT0MgXiIgV2FybmluZzogIl4ge3BwIFZ9IF4iIGlzIHVudXNlZCIsCiAgd2FybmluZyBNU0csCiAgcmVwb3J0LWxpbmVhciBOUy4KcmVwb3J0LWxpbmVhciBbXyBgLT4gXyB8IE5TXSA6LSByZXBvcnQtbGluZWFyIE5TLgoKdHlwZSBjb3VudCBBIC0+IGxpc3QgQiAtPiBwcm9wLgpjb3VudCAobGFtIEYpIEUgOi0gcGkgeFwgY291bnQgKEYgeCkgRS4KY291bnQgKGFwcCBbWHxYU10pIEUgOi0gISwgY291bnQgWCBFLCBjb3VudCAoYXBwIFhTKSBFLgpjb3VudCAoYXBwIFtdKSBfIDotICEuCmNvdW50IFggRSA6LSB2YXJpYWJsZSBYLCAhLCBpbmNyIFggRS4KY291bnQgQSBfLgoKbW9kZSAoaW5jciBpIGkpLgppbmNyIFggW1ggYC0+IEsgfCBfXSA6LSBhZGQxIEsuCmluY3IgWCBbXyB8IFhTXSA6LSBpbmNyIFggWFMuCgptb2RlIChhZGQxIGkpLgphZGQxICh1dmFyIGFzIEspIDotIEsgPSAxICsgRlJFU0hfLgphZGQxICgxICsgSykgOi0gYWRkMSBLLgoKY2hlY2stbm9uLWxpbmVhciBbTnxOU10gKGFyZyBDKSBMIDotIHBpIHhcCiAocHAgeCBOIDotICEpID0+ICh2YXJpYWJsZSB4KSA9PiBjaGVjay1ub24tbGluZWFyIE5TIChDIHgpIFt4IGAtPiBGUkVTSF8gfCBMXS4KY2hlY2stbm9uLWxpbmVhciBbXSAoYXJnIEMpIEwgOi0gcGkgeFwKICh2YXJpYWJsZSB4KSA9PiBjaGVjay1ub24tbGluZWFyIE5TIChDIHgpIFt4IGAtPiBGUkVTSF8gfCBMXS4KY2hlY2stbm9uLWxpbmVhciBfIEMgTCA6LQogIGNvdW50IEMgTCwgcmVwb3J0LWxpbmVhciBMLgoKd2Fybi1saW5lYXIgW10uCndhcm4tbGluZWFyIFsgKGNsYXVzZSBMb2MgTmFtZXMgQ2xhdXNlKSB8Q1NdIDotCiAgY2hlY2tpbmcgTG9jID0+ICBjaGVjay1ub24tbGluZWFyIE5hbWVzIENsYXVzZSBbXSwKICB3YXJuLWxpbmVhciBDUy4KCiUgLS0tLS0tLS0tLSB0ZXN0IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCnR5cGUgZm9vIGludCAtPiBwcm9wLgp0eXBlIGZvbyBzdHJpbmcgLT4gcHJvcC4KCm1haW4gOi0gdGVzdDEsIHRlc3QyLCB0ZXN0MywgdGVzdDQsIHRlc3Q1LCB0ZXN0NiwgdGVzdDcsCiAgICAgICAgd2FybjEuCnRlc3QxIDotIGFwcCBsYW0uCnRlc3QyIDotIGxhbSBhcHAuCnRlc3QzIDotIGFwcCAib29wcyIuCnRlc3Q0IDotICBhcHAgW10gMi4KdGVzdDUgOi0gcHJpbnQgeCAyICIzeCIuCnRlc3Q2IDotIGZvbyAieCIsIGZvbyAxLCBmb28gYXBwLgp0ZXN0NyA6LSBmb28gKGZvbyBhcHApLgp3YXJuMSA6LSBMSU5FQVIuCgolIC0tLS0tLS0gZW50cnkgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpjaGVjayBQIFEgRGVjbGFyZWRUeXBlcyA6LQogIHR5cGVjaGVjay1wcm9ncmFtIFAgUSBEZWNsYXJlZFR5cGVzLCAhLCB3YXJuLWxpbmVhciBQLgoKJSB2aW06IHNldCBmdD1scHJvbG9nOgo=" }; { name = "elpi_quoted_syntax.elpi"; text = "LyogZWxwaTogZW1iZWRkZWQgbGFtYmRhIHByb2xvZyBpbnRlcnByZXRlciAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLwovKiBsaWNlbnNlOiBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgVmVyc2lvbiAyLjEgb3IgbGF0ZXIgICAgICAgICAgICovCi8qIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8KCiUgSE9BUyBmb3IgZWxwaSBwcm9ncmFtcwoKa2luZCB0ZXJtIHR5cGUuCgp0eXBlIGFwcCBsaXN0IHRlcm0gLT4gdGVybS4KdHlwZSBsYW0gKHRlcm0gLT4gdGVybSkgLT4gdGVybS4KdHlwZSBjb25zdCBzdHJpbmcgLT4gdGVybS4KCnR5cGUgY2RhdGEgY3R5cGUgImNkYXRhIiAtPiB0ZXJtLiAlIGludCwgc3RyaW5nLCBmbG9hdC4uIHNlZSBhbHNvICRpc19jZGF0YQoKdHlwZSBhcmcgKHRlcm0gLT4gdGVybSkgLT4gdGVybS4gICUgb25seSB0byBiaW5kIHRoZSBhcmdzIG9mIGEgY2xhdXNlCgpraW5kIGNsYXVzZSB0eXBlLgp0eXBlIGNsYXVzZSAoY3R5cGUgImxvYyIpIC0+IGxpc3Qgc3RyaW5nIC0+IHRlcm0gLT4gY2xhdXNlLgoKJSBhIHByb2dyYW0gaXMgdGhlbiBhIGxpc3Qgb2YgY2xhdXNlIHdoaWxlCiUgdGhlIHF1ZXJ5IGlzIGp1c3Qgb25lIGl0ZW0gb2YgdGhlIHNhbWUga2luZC4KCiUgc2VlIGVscGktY2hlY2tlci5lbHBpIGZvciBhbiBleGFtcGxlCgolIHZpbTogc2V0IGZ0PWxwcm9sb2c6Cgo=" }]
 let load () = List.iter (fun f -> Sys_js.create_file f.name (B64.decode f.text)) files
