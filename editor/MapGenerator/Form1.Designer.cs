namespace MapGenerator
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            components = new System.ComponentModel.Container();
            splitContainer1 = new SplitContainer();
            panel2 = new Panel();
            exportButton = new Button();
            layerGroup = new GroupBox();
            radioBlock = new RadioButton();
            radioL1 = new RadioButton();
            radioL0 = new RadioButton();
            assetsGroup = new GroupBox();
            assetList = new ListView();
            imageList1 = new ImageList(components);
            loadButton = new Button();
            saveButton = new Button();
            sizeBox = new GroupBox();
            generate = new Button();
            height = new NumericUpDown();
            label2 = new Label();
            width = new NumericUpDown();
            label1 = new Label();
            mapContainer = new Panel();
            saveFileDialog1 = new SaveFileDialog();
            openFileDialog1 = new OpenFileDialog();
            saveFileDialog2 = new SaveFileDialog();
            ((System.ComponentModel.ISupportInitialize)splitContainer1).BeginInit();
            splitContainer1.Panel1.SuspendLayout();
            splitContainer1.Panel2.SuspendLayout();
            splitContainer1.SuspendLayout();
            panel2.SuspendLayout();
            layerGroup.SuspendLayout();
            assetsGroup.SuspendLayout();
            sizeBox.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)height).BeginInit();
            ((System.ComponentModel.ISupportInitialize)width).BeginInit();
            SuspendLayout();
            // 
            // splitContainer1
            // 
            splitContainer1.Dock = DockStyle.Fill;
            splitContainer1.FixedPanel = FixedPanel.Panel1;
            splitContainer1.IsSplitterFixed = true;
            splitContainer1.Location = new Point(0, 0);
            splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            splitContainer1.Panel1.Controls.Add(panel2);
            // 
            // splitContainer1.Panel2
            // 
            splitContainer1.Panel2.Controls.Add(mapContainer);
            splitContainer1.Size = new Size(1378, 1494);
            splitContainer1.SplitterDistance = 450;
            splitContainer1.TabIndex = 0;
            // 
            // panel2
            // 
            panel2.BorderStyle = BorderStyle.FixedSingle;
            panel2.Controls.Add(exportButton);
            panel2.Controls.Add(layerGroup);
            panel2.Controls.Add(assetsGroup);
            panel2.Controls.Add(loadButton);
            panel2.Controls.Add(saveButton);
            panel2.Controls.Add(sizeBox);
            panel2.Dock = DockStyle.Fill;
            panel2.Location = new Point(0, 0);
            panel2.Name = "panel2";
            panel2.Padding = new Padding(5);
            panel2.Size = new Size(450, 1494);
            panel2.TabIndex = 0;
            // 
            // exportButton
            // 
            exportButton.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            exportButton.Location = new Point(16, 1362);
            exportButton.Name = "exportButton";
            exportButton.Size = new Size(415, 34);
            exportButton.TabIndex = 6;
            exportButton.Text = "Export";
            exportButton.UseVisualStyleBackColor = true;
            exportButton.Click += exportButton_Click;
            // 
            // layerGroup
            // 
            layerGroup.Controls.Add(radioBlock);
            layerGroup.Controls.Add(radioL1);
            layerGroup.Controls.Add(radioL0);
            layerGroup.Dock = DockStyle.Top;
            layerGroup.Location = new Point(5, 1260);
            layerGroup.Name = "layerGroup";
            layerGroup.Size = new Size(438, 83);
            layerGroup.TabIndex = 5;
            layerGroup.TabStop = false;
            layerGroup.Text = "Layer";
            // 
            // radioBlock
            // 
            radioBlock.AutoSize = true;
            radioBlock.Location = new Point(308, 40);
            radioBlock.Name = "radioBlock";
            radioBlock.Size = new Size(79, 29);
            radioBlock.TabIndex = 2;
            radioBlock.Text = "Block";
            radioBlock.UseVisualStyleBackColor = true;
            // 
            // radioL1
            // 
            radioL1.AutoSize = true;
            radioL1.Location = new Point(168, 40);
            radioL1.Name = "radioL1";
            radioL1.Size = new Size(93, 29);
            radioL1.TabIndex = 1;
            radioL1.Text = "Layer 1";
            radioL1.UseVisualStyleBackColor = true;
            // 
            // radioL0
            // 
            radioL0.AutoSize = true;
            radioL0.Checked = true;
            radioL0.Location = new Point(36, 40);
            radioL0.Name = "radioL0";
            radioL0.Size = new Size(93, 29);
            radioL0.TabIndex = 0;
            radioL0.TabStop = true;
            radioL0.Text = "Layer 0";
            radioL0.UseVisualStyleBackColor = true;
            // 
            // assetsGroup
            // 
            assetsGroup.Controls.Add(assetList);
            assetsGroup.Dock = DockStyle.Top;
            assetsGroup.Location = new Point(5, 176);
            assetsGroup.Name = "assetsGroup";
            assetsGroup.Padding = new Padding(7);
            assetsGroup.Size = new Size(438, 1084);
            assetsGroup.TabIndex = 4;
            assetsGroup.TabStop = false;
            assetsGroup.Text = "Assets";
            assetsGroup.Visible = false;
            // 
            // assetList
            // 
            assetList.Dock = DockStyle.Fill;
            assetList.GroupImageList = imageList1;
            assetList.LargeImageList = imageList1;
            assetList.Location = new Point(7, 31);
            assetList.Name = "assetList";
            assetList.Size = new Size(424, 1046);
            assetList.SmallImageList = imageList1;
            assetList.TabIndex = 0;
            assetList.TileSize = new Size(64, 64);
            assetList.UseCompatibleStateImageBehavior = false;
            assetList.ItemSelectionChanged += assetList_ItemSelectionChanged;
            // 
            // imageList1
            // 
            imageList1.ColorDepth = ColorDepth.Depth32Bit;
            imageList1.ImageSize = new Size(92, 92);
            imageList1.TransparentColor = Color.Transparent;
            // 
            // loadButton
            // 
            loadButton.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            loadButton.Location = new Point(16, 1402);
            loadButton.Name = "loadButton";
            loadButton.Size = new Size(415, 34);
            loadButton.TabIndex = 3;
            loadButton.Text = "Load";
            loadButton.UseVisualStyleBackColor = true;
            loadButton.Click += loadButton_Click;
            // 
            // saveButton
            // 
            saveButton.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            saveButton.Location = new Point(16, 1442);
            saveButton.Name = "saveButton";
            saveButton.Size = new Size(415, 34);
            saveButton.TabIndex = 2;
            saveButton.Text = "Save";
            saveButton.UseVisualStyleBackColor = true;
            saveButton.Click += saveButton_Click;
            // 
            // sizeBox
            // 
            sizeBox.Controls.Add(generate);
            sizeBox.Controls.Add(height);
            sizeBox.Controls.Add(label2);
            sizeBox.Controls.Add(width);
            sizeBox.Controls.Add(label1);
            sizeBox.Dock = DockStyle.Top;
            sizeBox.Location = new Point(5, 5);
            sizeBox.Name = "sizeBox";
            sizeBox.Size = new Size(438, 171);
            sizeBox.TabIndex = 1;
            sizeBox.TabStop = false;
            sizeBox.Text = "Size";
            // 
            // generate
            // 
            generate.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            generate.Location = new Point(10, 118);
            generate.Name = "generate";
            generate.Size = new Size(412, 34);
            generate.TabIndex = 4;
            generate.Text = "Generate";
            generate.UseVisualStyleBackColor = true;
            generate.Click += generate_Click;
            // 
            // height
            // 
            height.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            height.Location = new Point(242, 71);
            height.Maximum = new decimal(new int[] { 50, 0, 0, 0 });
            height.Name = "height";
            height.Size = new Size(180, 31);
            height.TabIndex = 3;
            height.TextAlign = HorizontalAlignment.Right;
            height.Value = new decimal(new int[] { 25, 0, 0, 0 });
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI Semibold", 9F, FontStyle.Bold, GraphicsUnit.Point);
            label2.Location = new Point(16, 71);
            label2.Name = "label2";
            label2.Size = new Size(68, 25);
            label2.TabIndex = 2;
            label2.Text = "Height";
            // 
            // width
            // 
            width.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            width.Location = new Point(242, 34);
            width.Maximum = new decimal(new int[] { 75, 0, 0, 0 });
            width.Name = "width";
            width.Size = new Size(180, 31);
            width.TabIndex = 1;
            width.TextAlign = HorizontalAlignment.Right;
            width.Value = new decimal(new int[] { 25, 0, 0, 0 });
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI Semibold", 9F, FontStyle.Bold, GraphicsUnit.Point);
            label1.Location = new Point(16, 34);
            label1.Name = "label1";
            label1.Size = new Size(62, 25);
            label1.TabIndex = 0;
            label1.Text = "Width";
            // 
            // mapContainer
            // 
            mapContainer.BackgroundImage = Properties.Resources.water;
            mapContainer.BorderStyle = BorderStyle.FixedSingle;
            mapContainer.Dock = DockStyle.Fill;
            mapContainer.Location = new Point(0, 0);
            mapContainer.Name = "mapContainer";
            mapContainer.Size = new Size(924, 1494);
            mapContainer.TabIndex = 0;
            // 
            // saveFileDialog1
            // 
            saveFileDialog1.Filter = "Generator|*.gen";
            // 
            // openFileDialog1
            // 
            openFileDialog1.FileName = "openFileDialog1";
            openFileDialog1.Filter = "Generator|*.gen";
            // 
            // saveFileDialog2
            // 
            saveFileDialog2.Filter = "Level|*.json";
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(10F, 25F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1378, 1494);
            Controls.Add(splitContainer1);
            Name = "Form1";
            Text = "Form1";
            WindowState = FormWindowState.Maximized;
            splitContainer1.Panel1.ResumeLayout(false);
            splitContainer1.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)splitContainer1).EndInit();
            splitContainer1.ResumeLayout(false);
            panel2.ResumeLayout(false);
            layerGroup.ResumeLayout(false);
            layerGroup.PerformLayout();
            assetsGroup.ResumeLayout(false);
            sizeBox.ResumeLayout(false);
            sizeBox.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)height).EndInit();
            ((System.ComponentModel.ISupportInitialize)width).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private SplitContainer splitContainer1;
        private Panel panel2;
        private Panel mapContainer;
        private GroupBox sizeBox;
        private Label label1;
        private Button loadButton;
        private Button saveButton;
        private NumericUpDown height;
        private Label label2;
        private NumericUpDown width;
        private Button generate;
        private GroupBox assetsGroup;
        private ListView assetList;
        private ImageList imageList1;
        private GroupBox layerGroup;
        private RadioButton radioL1;
        private RadioButton radioL0;
        private Button exportButton;
        private RadioButton radioBlock;
        private SaveFileDialog saveFileDialog1;
        private OpenFileDialog openFileDialog1;
        private SaveFileDialog saveFileDialog2;
    }
}
