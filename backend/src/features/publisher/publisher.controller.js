const Publisher = require('./publisher.model');
const AdminLog = require('../admin_logs/admin_log.model');

const fs = require('fs');
const path = require('path');

/* =========================
   HELPER: DELETE FILE
========================= */
const deleteFileIfExists = (filePath) => {
  if (!filePath) return;

  const fullPath = path.join(__dirname, '../../../public', filePath);
  if (fs.existsSync(fullPath)) {
    fs.unlinkSync(fullPath);
  }
};

/* =========================
   HELPER: CREATE ADMIN LOG
========================= */
const createAdminLog = async (req, action, details = null) => {
  try {
    if (!req.auth || !req.auth.id) return;

    await AdminLog.create({
      admin_id: req.auth.id,
      action,
      details,
    });
  } catch (err) {
    console.error('AdminLog Error:', err.message);
  }
};


/* =========================
   1. GET ALL PUBLISHERS
========================= */
exports.getAllPublishers = async (req, res) => {
  try {
    const data = await Publisher.findAll({
      order: [['name', 'ASC']],
    });

    res.json({
      success: true,
      data,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/* =========================
   2. GET PUBLISHER BY ID
========================= */
exports.getPublisherById = async (req, res) => {
  try {
    const publisher = await Publisher.findByPk(req.params.id);

    if (!publisher) {
      return res.status(404).json({
        success: false,
        message: 'Publisher tidak ditemukan',
      });
    }

    res.json({
      success: true,
      data: publisher,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/* =========================
   3. CREATE PUBLISHER
========================= */
exports.createPublisher = async (req, res) => {
  try {
    const { name, website } = req.body;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: 'Nama wajib diisi',
      });
    }

    const logo_url = req.file
      ? `/uploads/publishers/${req.file.filename}`
      : null;

    const publisher = await Publisher.create({
      name,
      website,
      logo_url,
    });

    // 🔴 ADMIN LOG
    await createAdminLog(
      req,
      'Create Publisher',
      `Publisher "${name}" berhasil dibuat`
    );

    res.status(201).json({
      success: true,
      message: 'Publisher berhasil dibuat',
      data: publisher,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/* =========================
   4. UPDATE PUBLISHER
========================= */
exports.updatePublisher = async (req, res) => {
  try {
    const { name, website } = req.body;
    const publisher = await Publisher.findByPk(req.params.id);

    if (!publisher) {
      return res.status(404).json({
        success: false,
        message: 'Publisher tidak ditemukan',
      });
    }

    let logo_url = publisher.logo_url;

    if (req.file) {
      deleteFileIfExists(publisher.logo_url);
      logo_url = `/uploads/publishers/${req.file.filename}`;
    }

    await publisher.update({
      name: name ?? publisher.name,
      website: website ?? publisher.website,
      logo_url,
    });

    // 🔴 ADMIN LOG
    await createAdminLog(
      req,
      'Update Publisher',
      `Publisher ID ${publisher.id} diupdate`
    );

    res.json({
      success: true,
      message: 'Publisher berhasil diupdate',
      data: publisher,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/* =========================
   5. DELETE PUBLISHER
========================= */
exports.deletePublisher = async (req, res) => {
  try {
    const publisher = await Publisher.findByPk(req.params.id);

    if (!publisher) {
      return res.status(404).json({
        success: false,
        message: 'Publisher tidak ditemukan',
      });
    }

    deleteFileIfExists(publisher.logo_url);
    await publisher.destroy();

    // 🔴 ADMIN LOG
    await createAdminLog(
      req,
      'Delete Publisher',
      `Publisher "${publisher.name}" dihapus`
    );

    res.json({
      success: true,
      message: 'Publisher berhasil dihapus',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
