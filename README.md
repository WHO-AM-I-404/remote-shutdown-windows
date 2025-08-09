# Remote Shutdown & Restart via Command Prompt

This guide explains how to remotely shutdown or restart another Windows computer on the same network using either **computer name** or **IP address**. It covers all required settings, firewall configuration, and usage.

> \*\* Important:\*\* You must have administrator privileges on both computers, and both must be in the same network or domain.

---

## 1. Requirements

1. Two Windows PCs (Windows 7, 10, or 11)
2. Both connected to the same local network (Wi-Fi or Ethernet)
3. Administrator account credentials for the target PC
4. Firewall permissions enabled for remote shutdown

---

## 2. Prepare the Target Computer (PC to be controlled)

### Step 2.1: Enable Remote Administration

1. Press **Windows + R**, type `services.msc`, and press **Enter**.
2. Find **Remote Registry** service.
3. Double-click it, set **Startup type** to `Automatic`, and click **Start**.

### Step 2.2: Allow Remote Shutdown in Local Security Policy

1. Press **Windows + R**, type `secpol.msc`, press **Enter**.
2. Navigate to:

   ```
   Security Settings → Local Policies → User Rights Assignment
   ```
3. Double-click **Force shutdown from a remote system**.
4. Click **Add User or Group…**, enter your **admin account name** from the controller PC, click **OK**.

### Step 2.3: Configure Firewall

1. Press **Windows + R**, type `wf.msc`, press **Enter**.
2. In the left panel, click **Inbound Rules**.
3. Find and enable these rules:

   * **Remote Shutdown (RPC)**
   * **Windows Management Instrumentation (WMI-In)**
4. Right-click each, choose **Enable Rule**.

---

## 3. Get Target Computer Name or IP Address

### Option 1: Get Computer Name

1. On the target PC, press **Windows + R**, type `cmd`, press **Enter**.
2. Type:

   ```
   hostname
   ```
3. Note the output (e.g., `DESKTOP-123ABC`).

### Option 2: Get IP Address

1. On the target PC, open **Command Prompt**.
2. Type:

   ```
   ipconfig
   ```
3. Look for the **IPv4 Address** (e.g., `192.168.1.25`).

---

## 4. Execute Remote Shutdown or Restart from Controller PC

1. On your controller PC, open **Command Prompt as Administrator**.

### Shutdown by Computer Name

```cmd
shutdown /s /m \\COMPUTERNAME /t 0 /f
```

Replace `COMPUTERNAME` with the actual target name.

### Shutdown by IP Address

```cmd
shutdown /s /m \\192.168.1.25 /t 0 /f
```

Replace `192.168.1.25` with the actual target IP.

### Restart by Computer Name

```cmd
shutdown /r /m \\COMPUTERNAME /t 0 /f
```

### Restart by IP Address

```cmd
shutdown /r /m \\192.168.1.25 /t 0 /f
```

**Command Flags:**

* `/s` → Shutdown
* `/r` → Restart
* `/m` → Specify remote machine
* `/t 0` → Time delay in seconds (0 means immediate)
* `/f` → Force close running apps

---

## 5. Testing & Troubleshooting

* Ensure both PCs are on the same network.
* Make sure firewall rules are enabled on target PC.
* Check if you can ping the target:

```cmd
ping 192.168.1.25
```

* If `Access Denied` appears, verify that your admin account is added to **Force shutdown from a remote system** in the target’s local security policy.

---

## Example Workflow

1. **On Target PC:** Enable Remote Registry, allow firewall rules, add controller account in Local Security Policy.
2. **Get IP or Name:** `hostname` or `ipconfig`.
3. **On Controller PC:** Run shutdown/restart command with IP or name.
4. **Verify:** Target PC should shutdown or restart instantly.

---

&#x20;You now have a fully configured remote shutdown system over a local network.
