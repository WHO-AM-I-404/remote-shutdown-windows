# remote shutdown windows

This guide explains, step-by-step, how to enable and execute a remote shutdown or restart on a target Windows PC from another Windows PC within the same network.

---

## 1. Requirements

* Both PCs must be on the **same local network** (LAN/Wi-Fi).
* You have **admin access** to the target PC.
* Target PC is running **Windows 7, 8, 10, or 11**.
* Remote shutdown settings enabled on the target PC.

---

## 2. Enable Remote Shutdown on Target PC

1. **Enable File and Printer Sharing**:

   * Press `Win + R`, type `control`, and press Enter.
   * Go to **Network and Sharing Center** → **Advanced sharing settings**.
   * Turn on **File and printer sharing**.

2. **Allow Remote Shutdown in Firewall**:

   * Press `Win + R`, type `wf.msc`, and press Enter.
   * Go to **Inbound Rules** → Find **Windows Management Instrumentation (WMI-In)** and **Remote Shutdown**.
   * Enable these rules.

3. **Grant Shutdown Permissions**:

   * Press `Win + R`, type `secpol.msc`, and press Enter.
   * Go to **Local Policies** → **User Rights Assignment**.
   * Open **Force shutdown from a remote system**.
   * Add your **admin account** from the controlling PC.

---

## 3. Identify Target PC Information

* **Get PC Name**:

  * On target PC, press `Win + R`, type `cmd`, press Enter.
  * Type: `hostname`
* **Get IP Address**:

  * On target PC, type: `ipconfig`

---

## 4. Execute Remote Shutdown

On the controlling PC:

1. Press `Win + R`, type `cmd`, and press Enter.
2. Use one of the commands:

   * Shutdown by PC name:

     ```cmd
     shutdown /s /m \\PC_NAME /t 0
     ```
   * Shutdown by IP address:

     ```cmd
     shutdown /s /m \\IP_ADDRESS /t 0
     ```
   * Restart:

     ```cmd
     shutdown /r /m \\PC_NAME /t 0
     ```

**Notes:**

* Replace `PC_NAME` or `IP_ADDRESS` with the actual target.
* `/s` = shutdown, `/r` = restart, `/t 0` = no delay.

---

## 5. Tips

* If firewall blocks the connection, double-check that **WMI-In** and **Remote Shutdown** rules are enabled.
* You don’t need to set the target name on your PC — just use the actual PC name or IP.
* For Windows Home editions, you may need to tweak registry settings to allow `secpol.msc` equivalents.

---

## 6. Security Warning

This should only be done on PCs you own or have permission to manage. Unauthorized use can be illegal.
