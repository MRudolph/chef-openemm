openemm Cookbook
================

*Warning: This Cookbook is very alpha and buggy* 

Installs the openemm email-software.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.


Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### openemm::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['openemm']['sysgroup']</tt></td>
    <td>String</td>
    <td>The group which the openemm-user will belong to</td>
    <td><tt>openemm</tt></td>
  </tr>
</table>

Usage
-----
#### openemm::default
Installs OpenEMM. Only the sysgroup can be changed.
Donwloads Java and Tomcat to hard-coded paths.
