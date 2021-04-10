---
author: "@klinkby"
keywords:
- azure
- performance
date: "2015-09-30T22:00:00Z"
description: ""
draft: false
slug: azure-response-time
tags:
- azure
- performance
title: Azure Europe response times
---


A note on response times from the two local Azure data centers to **Copenhagen, DK**.

I created a public BLOB container in each of the data centers North Europe (Dublin, IE) and West Europe (Amsterdan, NL), and monitored the Network tab in Chrome while issusing HTTP requests to the BLOB containers.

Times in miliseconds:
  <table> <thead> <tr> <th >Req#</th> <th >West Europe </th> <th > North Europe</th> </tr> </thead>  <tbody> <tr> <td >1</td> <td >36</td> <td >50</td> </tr>  <tr> <td >2</td> <td >34</td> <td >51</td> </tr>  <tr> <td >3</td> <td >52</td> <td >52</td> </tr>  <tr> <td >4</td> <td >37</td> <td >50</td> </tr>  <tr> <td >5</td> <td >44</td> <td >53</td> </tr>  <tr> <td >6</td> <td >40</td> <td >56</td> </tr>  <tr> <td >7</td> <td >38</td> <td >50</td> </tr>  <tr> <td >8</td> <td >40</td> <td >52</td> </tr>  <tr> <td >9</td> <td >36</td> <td >52</td> </tr>  <tr> <td >10</td> <td >41</td> <td >54</td> </tr>  <tr> <td >**Average**</td> <td >**40**</td> <td >**52**</td> </tr> </tbody> </table>    

In October 2015 the **West Europe** data center provide **23% quicker** response time than the North Europe data center to Copenhagen, DK.

